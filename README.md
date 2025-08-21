# Archaeological Services and Site Management System

A comprehensive blockchain-based system for managing archaeological excavations, artifact documentation, site preservation, and stakeholder coordination using Clarity smart contracts.

## System Overview

This system provides transparent, immutable record-keeping for archaeological activities while facilitating collaboration between researchers, cultural heritage agencies, and indigenous communities.

### Core Components

1. **Site Registry Contract** (`site-registry.clar`)
    - Registers and manages archaeological sites
    - Tracks site status, coordinates, and metadata
    - Manages site access permissions

2. **Permit Management Contract** (`permit-management.clar`)
    - Issues and tracks excavation permits
    - Manages permit validity and conditions
    - Handles permit renewals and modifications

3. **Artifact Documentation Contract** (`artifact-documentation.clar`)
    - Records artifact discoveries and metadata
    - Tracks artifact provenance and chain of custody
    - Manages artifact classifications and descriptions

4. **Stakeholder Coordination Contract** (`stakeholder-coordination.clar`)
    - Manages researcher registrations and roles
    - Facilitates indigenous community consultation
    - Tracks benefit-sharing agreements

5. **Reporting System Contract** (`reporting-system.clar`)
    - Generates transparent reports for agencies
    - Tracks research progress and findings
    - Manages public access to non-sensitive data

## Key Features

- **Immutable Records**: All archaeological data is permanently recorded on-chain
- **Transparent Reporting**: Cultural heritage agencies have real-time access to activities
- **Community Consultation**: Built-in mechanisms for indigenous community involvement
- **Research Collaboration**: Secure data sharing between authorized researchers
- **Permit Compliance**: Automated tracking of permit conditions and validity
- **Artifact Provenance**: Complete chain of custody for all documented artifacts

## Data Types

### Site Information
- Site ID, coordinates, cultural significance level
- Discovery date, current status, access restrictions
- Associated permits and active research projects

### Permit Details
- Permit number, issuing authority, validity period
- Permitted activities, site restrictions, compliance status
- Researcher assignments and progress tracking

### Artifact Records
- Unique artifact ID, discovery context, physical description
- Cultural classification, estimated age, conservation status
- Chain of custody, current location, research access

### Stakeholder Data
- Researcher credentials, institutional affiliations
- Community representative contacts, consultation records
- Benefit-sharing agreements, compensation tracking

## Usage Workflow

1. **Site Registration**: Archaeological sites are registered with basic metadata
2. **Permit Application**: Researchers apply for excavation permits through the system
3. **Community Consultation**: Indigenous communities are notified and consulted
4. **Excavation Activities**: Permitted work proceeds with real-time documentation
5. **Artifact Recording**: All discoveries are immediately documented on-chain
6. **Progress Reporting**: Regular updates are submitted to heritage agencies
7. **Data Sharing**: Authorized researchers can access relevant historical data
8. **Benefit Distribution**: Community benefits are tracked and distributed

## Security & Privacy

- Role-based access control for sensitive cultural information
- Public transparency for general archaeological progress
- Protected indigenous cultural knowledge with community consent
- Immutable audit trail for all system activities

## Getting Started

1. Deploy all five contracts to the Stacks blockchain
2. Initialize the system with authorized heritage agencies
3. Register archaeological sites and research institutions
4. Begin permit application and excavation documentation process

## Testing

Run the comprehensive test suite with:
\`\`\`bash
npm test
\`\`\`

Tests cover all contract functions, error conditions, and integration scenarios.
