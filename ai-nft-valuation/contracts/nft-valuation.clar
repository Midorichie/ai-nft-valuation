;; contracts/nft-valuation.clar
;; This contract handles NFT price valuation with enhanced security and functionality

;; ----- Constant Definitions -----
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u401))
(define-constant ERR_NFT_NOT_FOUND (err u404))
(define-constant ERR_INVALID_PRICE (err u400))

;; ----- Data Maps -----
(define-map nft-price-map {nft-id: uint} {price: uint, last-updated: uint, valuation-history: (list 5 uint)})

;; ----- Private Functions -----
(define-private (is-contract-owner)
  (is-eq tx-sender CONTRACT_OWNER)
)

(define-private (validate-price (price uint))
  (if (> price u0)
    true
    false
  )
)

;; ----- Public Functions -----
;; Set NFT price by ID (only owner)
(define-public (set-price (nft-id uint) (price uint))
  (begin
    (asserts! (is-contract-owner) ERR_NOT_AUTHORIZED)
    (asserts! (validate-price price) ERR_INVALID_PRICE)
    
    (let ((current-block-height block-height)
          (current-entry (default-to {price: u0, last-updated: u0, valuation-history: (list)} 
                          (map-get? nft-price-map {nft-id: nft-id})))
          (current-history (get valuation-history current-entry)))
      
      (map-set nft-price-map 
               {nft-id: nft-id} 
               {
                 price: price, 
                 last-updated: current-block-height,
                 valuation-history: (unwrap-panic (as-max-len? (append current-history price) u5))
               })
      (ok price)
    )
  )
)

;; Get NFT price by ID
(define-read-only (get-price (nft-id uint))
  (match (map-get? nft-price-map {nft-id: nft-id})
    entry (ok (get price entry))
    (err ERR_NFT_NOT_FOUND)
  )
)

;; Get full NFT valuation data
(define-read-only (get-valuation-data (nft-id uint))
  (match (map-get? nft-price-map {nft-id: nft-id})
    entry (ok entry)
    (err ERR_NFT_NOT_FOUND)
  )
)

;; Get average price from historical data
(define-read-only (get-average-price (nft-id uint))
  (match (map-get? nft-price-map {nft-id: nft-id})
    entry (let ((history (get valuation-history entry))
                (count (len history)))
            (if (> count u0)
                (ok (/ (fold + history u0) count))
                (ok u0)))
    (err ERR_NFT_NOT_FOUND)
  )
)

;; Update NFT price based on AI valuation - requires authorization
(define-public (update-ai-price (nft-id uint) (ai-price uint))
  (begin
    (asserts! (is-contract-owner) ERR_NOT_AUTHORIZED)
    (asserts! (validate-price ai-price) ERR_INVALID_PRICE)
    
    (let ((current-block-height block-height)
          (current-entry (default-to {price: u0, last-updated: u0, valuation-history: (list)} 
                          (map-get? nft-price-map {nft-id: nft-id})))
          (current-history (get valuation-history current-entry)))
      
      (map-set nft-price-map 
               {nft-id: nft-id} 
               {
                 price: ai-price, 
                 last-updated: current-block-height,
                 valuation-history: (unwrap-panic (as-max-len? (append current-history ai-price) u5))
               })
      (ok ai-price)
    )
  )
)
