;; contracts/nft-ownership.clar
;; This is a minimal viable NFT ownership contract with essential functionality

;; ----- Constant Definitions -----
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u401))
(define-constant ERR_NFT_NOT_FOUND (err u404))
(define-constant ERR_ALREADY_OWNED (err u409))
(define-constant ERR_NOT_OWNER (err u403))

;; ----- Data Maps -----
(define-map nft-ownership-map {nft-id: uint} {owner: principal, metadata: (string-ascii 256)})

;; ----- Public Functions -----
;; Register a new NFT
(define-public (register-nft (nft-id uint) (metadata (string-ascii 256)))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (asserts! (is-none (map-get? nft-ownership-map {nft-id: nft-id})) ERR_ALREADY_OWNED)
    (map-set nft-ownership-map {nft-id: nft-id} {owner: CONTRACT_OWNER, metadata: metadata})
    (contract-call? 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-valuation set-price nft-id u100)
  )
)

;; Transfer NFT to a new owner - minimal version
(define-public (transfer-nft (nft-id uint) (new-owner principal))
  (begin
    (asserts! (is-some (map-get? nft-ownership-map {nft-id: nft-id})) ERR_NFT_NOT_FOUND)
    (asserts! (is-eq tx-sender (get owner (unwrap-panic (map-get? nft-ownership-map {nft-id: nft-id})))) ERR_NOT_OWNER)
    (map-set nft-ownership-map {nft-id: nft-id} 
             {owner: new-owner, metadata: (get metadata (unwrap-panic (map-get? nft-ownership-map {nft-id: nft-id})))})
    (ok true)
  )
)

;; Get NFT owner
(define-read-only (get-nft-owner (nft-id uint))
  (match (map-get? nft-ownership-map {nft-id: nft-id})
    entry (ok (get owner entry))
    (err ERR_NFT_NOT_FOUND)
  )
)

;; Get NFT metadata
(define-read-only (get-nft-metadata (nft-id uint))
  (match (map-get? nft-ownership-map {nft-id: nft-id})
    entry (ok (get metadata entry))
    (err ERR_NFT_NOT_FOUND)
  )
)
