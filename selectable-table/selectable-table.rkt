#lang racket/base

(provide row render-selectable-table)

(struct row (state cells))

(define (render-table-row clas cell-renderer)
    (lambda (r)
        (define rs (row-state r))
        (define rc (row-cells r))
        (if (eq? rs 'null)
            `(tr ((class ,clas))
                ,@(map cell-renderer rc))
            `(tr ((class ,(if (eq? rs 'active) (string-append clas " active") clas))
                  (data-state ,(symbol->string rs)))
                ,@(map cell-renderer rc)))))

(define (render-table-section sec clas row-renderer)
    (lambda (rows)
        `(,sec ((class ,clas)) ,@(map row-renderer rows))))

(define (render-table-cell clas)
    (lambda (cell) `(td ((class ,clas)) ,cell)))

(define (render-selectable-table headers rows)
    (define (render-table-headers hdrs)
        (define (render-table-header-row hrd-row)
            ((render-table-row "header-row" (render-table-cell "table-cell")) hrd-row))
        ((render-table-section 'thead "table-header" render-table-header-row) hdrs))

    (define (render-selectable-table-body rws)
        (define (render-table-selectable-row rw)
            ((render-table-row "selectable-row" (render-table-cell "table-cell")) rw))
        ((render-table-section 'tbody "table-body" render-table-selectable-row) rws))
    
    `(table ((class "selectable-table"))
        ,(render-table-headers headers)
        ,(render-selectable-table-body rows)))