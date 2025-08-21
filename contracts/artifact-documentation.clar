;; Artifact Documentation Contract
;; Records and tracks archaeological artifacts

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u300))
(define-constant ERR-ARTIFACT-EXISTS (err u301))
(define-constant ERR-ARTIFACT-NOT-FOUND (err u302))
(define-constant ERR-INVALID-PERMIT (err u303))
(define-constant ERR-INVALID-CLASSIFICATION (err u304))

;; Classification constants
(define-constant CLASS-POTTERY u1)
(define-constant CLASS-TOOLS u2)
(define-constant CLASS-JEWELRY u3)
(define-constant CLASS-WEAPONS u4)
(define-constant CLASS-BONES u5)
(define-constant CLASS-OTHER u6)

;; Conservation status constants
(define-constant CONSERVATION-EXCELLENT u1)
(define-constant CONSERVATION-GOOD u2)
(define-constant CONSERVATION-FAIR u3)
(define-constant CONSERVATION-POOR u4)
(define-constant CONSERVATION-CRITICAL u5)

;; Data structures
(define-map artifacts
  { artifact-id: uint }
  {
    site-id: uint,
    permit-id: uint,
    discoverer: principal,
    discovery-date: uint,
    coordinates: { x: int, y: int, z: int },
    classification: uint,
    description: (string-ascii 300),
    estimated-age: uint,
    conservation-status: uint,
    current-location: (string-ascii 100)
  }
)

(define-map artifact-custody
  { artifact-id: uint, sequence: uint }
  {
    custodian: principal,
    transfer-date: uint,
    location: (string-ascii 100),
    purpose: (string-ascii 200)
  }
)

(define-map artifact-research
  { artifact-id: uint, researcher: principal }
  {
    access-granted: uint,
    research-purpose: (string-ascii 200),
    access-level: uint
  }
)

;; Contract variables
(define-data-var contract-owner principal tx-sender)
(define-data-var next-artifact-id uint u1)

;; Authorization check
(define-private (is-authorized (caller principal))
  (is-eq caller (var-get contract-owner))
)

;; Document new artifact discovery
(define-public (document-artifact
  (site-id uint)
  (permit-id uint)
  (coordinates-x int)
  (coordinates-y int)
  (coordinates-z int)
  (classification uint)
  (description (string-ascii 300))
  (estimated-age uint)
  (conservation-status uint)
  (current-location (string-ascii 100))
)
  (let ((artifact-id (var-get next-artifact-id)))
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    ;; replaced &lt; with < for native Clarity syntax
    (asserts! (and (>= classification CLASS-POTTERY) (<= classification CLASS-OTHER)) ERR-INVALID-CLASSIFICATION)
    (asserts! (is-none (map-get? artifacts { artifact-id: artifact-id })) ERR-ARTIFACT-EXISTS)

    (map-set artifacts
      { artifact-id: artifact-id }
      {
        site-id: site-id,
        permit-id: permit-id,
        discoverer: tx-sender,
        discovery-date: block-height,
        coordinates: { x: coordinates-x, y: coordinates-y, z: coordinates-z },
        classification: classification,
        description: description,
        estimated-age: estimated-age,
        conservation-status: conservation-status,
        current-location: current-location
      }
    )

    ;; Initial custody record
    (map-set artifact-custody
      { artifact-id: artifact-id, sequence: u1 }
      {
        custodian: tx-sender,
        transfer-date: block-height,
        location: current-location,
        purpose: "Initial documentation"
      }
    )

    (var-set next-artifact-id (+ artifact-id u1))
    (ok artifact-id)
  )
)

;; Transfer artifact custody
(define-public (transfer-custody
  (artifact-id uint)
  (new-custodian principal)
  (new-location (string-ascii 100))
  (purpose (string-ascii 200))
  (sequence uint)
)
  (let ((artifact (unwrap! (map-get? artifacts { artifact-id: artifact-id }) ERR-ARTIFACT-NOT-FOUND)))
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)

    (map-set artifact-custody
      { artifact-id: artifact-id, sequence: sequence }
      {
        custodian: new-custodian,
        transfer-date: block-height,
        location: new-location,
        purpose: purpose
      }
    )

    ;; Update current location in artifact record
    (map-set artifacts
      { artifact-id: artifact-id }
      (merge artifact { current-location: new-location })
    )
    (ok true)
  )
)

;; Grant research access to artifact
(define-public (grant-research-access
  (artifact-id uint)
  (researcher principal)
  (research-purpose (string-ascii 200))
  (access-level uint)
)
  (begin
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-some (map-get? artifacts { artifact-id: artifact-id })) ERR-ARTIFACT-NOT-FOUND)

    (map-set artifact-research
      { artifact-id: artifact-id, researcher: researcher }
      {
        access-granted: block-height,
        research-purpose: research-purpose,
        access-level: access-level
      }
    )
    (ok true)
  )
)

;; Update conservation status
(define-public (update-conservation-status (artifact-id uint) (new-status uint))
  (let ((artifact (unwrap! (map-get? artifacts { artifact-id: artifact-id }) ERR-ARTIFACT-NOT-FOUND)))
    (asserts! (is-authorized tx-sender) ERR-NOT-AUTHORIZED)
    ;; replaced &lt; with < for native Clarity syntax
    (asserts! (and (>= new-status CONSERVATION-EXCELLENT) (<= new-status CONSERVATION-CRITICAL)) ERR-INVALID-CLASSIFICATION)

    (map-set artifacts
      { artifact-id: artifact-id }
      (merge artifact { conservation-status: new-status })
    )
    (ok true)
  )
)

;; Get artifact details
(define-read-only (get-artifact (artifact-id uint))
  (map-get? artifacts { artifact-id: artifact-id })
)

;; Get custody record
(define-read-only (get-custody-record (artifact-id uint) (sequence uint))
  (map-get? artifact-custody { artifact-id: artifact-id, sequence: sequence })
)

;; Get research access
(define-read-only (get-research-access (artifact-id uint) (researcher principal))
  (map-get? artifact-research { artifact-id: artifact-id, researcher: researcher })
)

;; Get next artifact ID
(define-read-only (get-next-artifact-id)
  (var-get next-artifact-id)
)
