#lang web-server/insta

(require racket/pretty "text-input.rkt")

(define (start request)
    (render-example request "Example"))

(define form-id "example-form")

(define (render-example request lp)
    (define (response-generator embed/url)
        (response/xexpr
            `(html
                (head ((title "Example Text Input")))
                (body
                    ,(render-text-input "input-1" "" "input" form-id lp)
                    (form ((id ,form-id) (action ,(embed/url query-handler))))
                    (input ((type "submit") (value "Query") (form ,form-id)))))))

    (define (query-handler request)
        (define lp (extract-binding/single 'input-1 (request-bindings request)))
        (render-example request lp))

    (send/suspend/dispatch response-generator))