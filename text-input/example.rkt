#lang web-server/insta

(require racket/pretty "text-input.rkt")

(define (start request)
    (render-example request default-inputs))

(define form-id 'example-form)
(define input-ids (list 'input-1 'input-2))
(define default-inputs (map 
    (lambda (id) (mk-simple-text-input id form-id "example input"))
    input-ids))

(define (render-example request inputs)
    (define (response-generator embed/url)
        (response/xexpr
            `(html
                (head ((title "Example Text Input")))
                (body
                    ,@(map render-text-input inputs)
                    (form ((id ,(symbol->string form-id)) (action ,(embed/url query-handler))))
                    (input ((type "submit") (value "Query") (form ,(symbol->string form-id))))))))

    (define (query-handler request)
        (define req-bindings (request-bindings request))
        (define inputs (map
            (lambda (id) (mk-simple-text-input id form-id (extract-binding/single id req-bindings)))
            input-ids))
        (render-example request inputs))

    (send/suspend/dispatch response-generator))