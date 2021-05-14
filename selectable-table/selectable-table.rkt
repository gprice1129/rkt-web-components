#lang racket/base

(provide (struct-out row) simple-row selectable-row render-selectable-table)

(struct row (id state cells) #:mutable)
(define (simple-row cells) (row 0 'inactive cells))
(define (selectable-row id state cells) (row id state cells))

(define (render-table-cell cls)
    (lambda (cell) `(td ((class ,cls)) ,cell)))

(define (render-table-row cls cell-renderer)
    (lambda (r)
        `(tr ((class ,(if (eq? (row-state r) 'active) (string-append cls " active") cls))
               (data-id ,(number->string (row-id r))))
             ,@(map cell-renderer (row-cells r)))))

(define (render-table-section sec cls row-renderer)
    (lambda (rows)
        `(,sec ((class ,cls)) ,@(map row-renderer rows))))

(define (render-selectable-table id headers rows)
    (define (render-table-headers hdrs)
        (define (render-table-header-row hdr)
            ((render-table-row "header-row" (render-table-cell "table-cell")) hdr))
        ((render-table-section 'thead "table-header" render-table-header-row) hdrs))

    (define (render-selectable-table-body rs)
        (define (render-table-selectable-row r)
            ((render-table-row "selectable-row" (render-table-cell "table-cell")) r))
        ((render-table-section 'tbody "table-body" render-table-selectable-row) rs))
    
    `(table ((id ,id) (class "selectable-table"))
        ,(render-table-headers headers)
        ,(render-selectable-table-body rows)))