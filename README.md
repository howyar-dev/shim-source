# Shim Source for Howyar SysReturn

## Source Code

This build uses **unaltered** Shim 16.1 source code from the official tarball:

- https://github.com/rhboot/shim/releases/download/16.1/shim-16.1.tar.bz2

## Certificate

- `vendor.cer` - The public portion of the certificate embedded in shim (DER format)

## Build Instructions

### Prerequisites

- Docker installed and running

### Build

```bash
# Clone this repository
git clone https://github.com/howyar-dev/shim-source.git
cd shim-source

# Build the shim binary
docker build --output type=local,dest=./output .
```

## Verification

### SHA256 Hash

```bash
sha256sum output/shimx64.efi
```

```text
150fdd153fbfa0b489afa85367cc0507ab778bad61529621b0dcf65ee10b726f  output/shimx64.efi
```

### File Type

```bash
file output/shimx64.efi
```

```text
output/shimx64.efi: PE32+ executable (EFI application) x86-64 (stripped to external PDB), for MS Windows
```


### SBAT Section

```bash
objcopy --dump-section .sbat=/dev/stdout output/shimx64.efi 2>/dev/null
```

```text
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,4,UEFI shim,shim,1,https://github.com/rhboot/shim
```



## Files Included

- `vendor.cer` - Embedded certificate (DER format)
- `Dockerfile` - Reproducible build environment definition
- `build-logs/` - Complete build logs from the build process
- `docker-build.log` - Main build log

## Build Environment

- Base image: Ubuntu 22.04 LTS
- Toolchain: gcc, binutils, gnu-efi (Ubuntu 22.04 packages)
- Shim version: 16.1
- Architecture: x86_64

## Notes

- No patches were applied to the Shim source code
- Only the `vendor.cer` certificate was embedded via `VENDOR_CERT_FILE`
- `ENABLE_SBAT=1` was set to include SBAT metadata
- `DEFAULT_LOADER="\\\\osldr.efi"` was set as the default bootloader
