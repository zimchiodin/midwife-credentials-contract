# MidwifeCredentials - Professional Certification System

A blockchain-based credential management system for midwives, ensuring verifiable and tamper-proof professional certifications on the Stacks network.

## Features

- **Verifiable Credentials**: Immutable storage of midwife certifications and licenses
- **Authority Management**: Only authorized certification bodies can issue credentials
- **Expiration Tracking**: Automatic validation of credential expiry dates
- **Specialization Records**: Track specialized skills and training areas
- **Status Management**: Enable/disable credentials as needed

## Contract Functions

### Public Functions
- `add-certification-authority(authority)` - Add authorized certification body (owner only)
- `issue-credential(...)` - Issue new midwife credential (authorities only)
- `update-credential-status(midwife, active)` - Update credential active status

### Read-Only Functions
- `get-credentials(midwife)` - Retrieve complete credential information
- `is-certified-active(midwife)` - Check if midwife has valid, active credentials
- `is-certification-authority(authority)` - Verify authority status
- `get-expiry-date(midwife)` - Get credential expiration date

## Data Structure

Each credential includes:
- Full name and license number
- Certification level and specializations
- Issue and expiry dates
- Issuing authority information
- Active/inactive status

## Usage

1. Deploy contract and add certification authorities
2. Authorities issue credentials to qualified midwives
3. Anyone can verify midwife credentials and status
4. Authorities can update credential status as needed

## Security

- Multi-authority system prevents single point of failure
- Automatic expiration validation
- Immutable credential history
- Principal-based authentication

## License

MIT License