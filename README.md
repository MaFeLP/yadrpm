# yadrpm
A discord rich presence creator based on discord's game SDK.

## Building
### Dependencies
#### Windows
 - [git](https://git-scm.com/)
 - [cmake](https://cmake.org/)
 - [Visual Studio](https://)
#### Linux & MacOS
 - [curl](https://curl.se/)
 - [git](https://git-scm.com/)
 - [cmake](https://cmake.org/)
 - g++
### Instructions
1. Execute `curl -o "yadrpm-installer.sh" "https://raw.githubusercontent.com/MaFeLP/yadrpm/stable/bash-scripts/download.sh"`.
2. View and verify the downloaded file `yadrpm-installer.sh`. If you don't know bash, ask someone who does or trust me that this file is not suspicous.
3. Execute `bash "yadrpm-installer.sh"`
4. Answer both questions with `n`.

## Errors:
```
Log(4): Unhandled frame: Frame { opcode: Close, data: [123, 34, 99, 111, 100, 101, 34, 58, 52, 48, 48, 48, 44, 34, 109, 101, 115, 115, 97, 103, 101, 34, 58, 34, 73, 110, 118, 97, 108, 105, 100, 32, 67, 108, 105, 101, 110, 116, 32, 73, 68, 34, 125] }
```

### How to get the normal error code
1. Install [Python](https://www.python.org/downloads/ "Python Download site").
2. Copy the numbers and the brackets (`[` & `]`).
3. open a terminal and type `python`. Then press Enter.
4. Paste the following code and replace `[...]` with the before copied list:

```python
data = [...]
bytes.fromhex("".join((hex(i)[2:] for i in data))).decode()
```

Example output:
```
$ python
Python 3.9.6 (default, Jun 30 2021, 10:22:16) 
[GCC 11.1.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> data = [123, 34, 99, 111, 100, 101, 34, 58, 52, 48, 48, 48, 44, 34, 109, 101, 115, 115, 97, 103, 101, 34, 58, 34, 73, 110, 118, 97, 108, 105, 100, 32, 67, 108, 105, 101, 110, 116, 32, 73, 68, 34, 125]
>>> bytes.fromhex("".join((hex(i)[2:] for i in data))).decode()
'{"code":4000,"message":"Invalid Client ID"}'
>>>
```

