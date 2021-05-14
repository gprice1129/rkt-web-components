#lang web-server/insta

(require racket/pretty racket/string json "selectable-table.rkt")

(define (start request)
    (render-example request))

(define (render-example request)
    (define (response-generator embed/url)
        (response/xexpr
            `(html
                (head (title "Selectable Table Example")
                    ,stylesheet)
                (body
                    ,(render-selectable-table TABLE-ID HEADERS (hash-map ROWS (lambda (k v) v)))
                    (form ((id "query") (action ,(embed/url delete-handler)))
                        (input ((type "hidden")
                                (name "query-data")
                                (id "query-data")
                                (value ""))))
                    (input ((type "submit")
                            (value "Delete selected rows")
                            (onclick "get_data_and_submit()")))
                    ,jquery
                    ,selectable-table-js 
                    ))))

    (define (delete-handler request)
        (define query-data (string->jsexpr
            (extract-binding/single 'query-data (request-bindings request))))
        
        (for ((elem query-data))
            (when (hash-has-key? elem 'state)
                (define table-state (list->set (map string->number (hash-ref elem 'state))))
                (hash-for-each ROWS
                    (lambda (k v)
                        (define row (hash-ref ROWS k))
                        (set-row-state! row (if (set-member? table-state k) 'active 'inactive))))))

        (render-example request))

    (send/suspend/dispatch response-generator))

(static-files-path "htdocs")
(define stylesheet
   '(link ((rel "stylesheet") (href "/style.css") (type "text/css"))))
(define jquery
    '(script ((src "/jquery-3.5.1.js"))))
(define selectable-table-js 
    '(script ((src "/selectable-table.js"))))
(define query-js
    '(script ((src "/query.js"))))

;;; static data
(define TABLE-ID "example-table")
(define HEADERS `(,(simple-row '("Type" "Cost"))))
(define ROWS (make-hash `(,(cons 0 (selectable-row 0 'inactive '("Ship" "$1000")))
                          ,(cons 1 (selectable-row 1 'active '("Mine" "$200"))))))