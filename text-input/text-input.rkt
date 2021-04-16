#lang racket/base

(provide render-text-input mk-simple-text-input (struct-out custom-text-input))

(struct custom-text-input (id form-id class label placeholder))
(define (mk-simple-text-input id form-id label)
    (custom-text-input id form-id "simple-text-input" label ""))
(define (render-text-input t)
    (define txt-id-string (symbol->string (custom-text-input-id t)))
    `(div
        (label ((class ,(custom-text-input-class t))) ,(custom-text-input-label t))
        (input ((id ,txt-id-string)
                (type "text")
                (name ,txt-id-string)
                (form ,(symbol->string (custom-text-input-form-id t)))
                (placeholder ,(custom-text-input-placeholder t))))))