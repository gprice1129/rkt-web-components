#lang racket/base

(provide render-text-input)

(define (render-text-input id label cls form-id placeholder)
    `(div
        (label ((class ,cls)) ,label)
        (input ((id ,id)
                (type "text")
                (name ,id)
                (form ,form-id)
                (placeholder ,placeholder)))))