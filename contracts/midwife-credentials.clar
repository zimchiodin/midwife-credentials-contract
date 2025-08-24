;; Midwife Credentials Contract
;; Manages professional certifications and credentials for midwives

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u200))
(define-constant err-not-found (err u201))
(define-constant err-already-certified (err u202))
(define-constant err-invalid-certification (err u203))
(define-constant err-expired (err u204))

(define-map midwife-credentials
  principal
  {
    full-name: (string-ascii 100),
    license-number: (string-ascii 50),
    certification-level: (string-ascii 30),
    issued-date: uint,
    expiry-date: uint,
    issuing-authority: (string-ascii 100),
    specializations: (list 5 (string-ascii 50)),
    is-active: bool
  }
)

(define-map certification-authorities principal bool)

;; Add certification authority
(define-public (add-certification-authority (authority principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set certification-authorities authority true))
  )
)

;; Issue midwife credential
(define-public (issue-credential
  (midwife principal)
  (full-name (string-ascii 100))
  (license-number (string-ascii 50))
  (certification-level (string-ascii 30))
  (expiry-date uint)
  (issuing-authority (string-ascii 100))
  (specializations (list 5 (string-ascii 50))))
  (begin
    (asserts! (default-to false (map-get? certification-authorities tx-sender)) err-owner-only)
    (asserts! (is-none (map-get? midwife-credentials midwife)) err-already-certified)
    (map-set midwife-credentials
      midwife
      {
        full-name: full-name,
        license-number: license-number,
        certification-level: certification-level,
        issued-date: stacks-block-height,
        expiry-date: expiry-date,
        issuing-authority: issuing-authority,
        specializations: specializations,
        is-active: true
      }
    )
    (ok true)
  )
)

;; Update credential status
(define-public (update-credential-status (midwife principal) (active bool))
  (let ((credential (unwrap! (map-get? midwife-credentials midwife) err-not-found)))
    (asserts! (default-to false (map-get? certification-authorities tx-sender)) err-owner-only)
    (map-set midwife-credentials
      midwife
      (merge credential {is-active: active})
    )
    (ok true)
  )
)

;; Get midwife credentials
(define-read-only (get-credentials (midwife principal))
  (map-get? midwife-credentials midwife)
)

;; Verify if midwife is certified and active
(define-read-only (is-certified-active (midwife principal))
  (match (map-get? midwife-credentials midwife)
    credential (and (get is-active credential) 
                   (> (get expiry-date credential) stacks-block-height))
    false
  )
)

;; Check if authority is authorized
(define-read-only (is-certification-authority (authority principal))
  (default-to false (map-get? certification-authorities authority))
)

;; Get credential expiry date
(define-read-only (get-expiry-date (midwife principal))
  (match (map-get? midwife-credentials midwife)
    credential (some (get expiry-date credential))
    none
  )
)