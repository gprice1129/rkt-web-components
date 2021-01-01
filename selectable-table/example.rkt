#lang web-server/insta

(require racket/pretty "selectable-table.rkt")

(define (start request)
    (render-example request))

(define (render-example request)
    (define (response-generator embed/url)
        (response/xexpr
            `(html
                (head (title "Selectable Table Example")
                    ,stylesheet)
                (body
                    ,(render-selectable-table HEADERS ROWS)
                    (form ((id "query") (action ,(embed/url query-handler)))
                        (input ((type "hidden")
                                (name "query-data")
                                (id "query-data")
                                (value ""))))
                    (input ((type "submit")
                            (value "Query")
                            (onclick "get_data_and_submit()")))
                    ,jquery
                    ,selectable-table-js 
                    ,query-js
                    ))))

    (define (query-handler request)
        (pretty-print (extract-binding/single 'query-data (request-bindings request)))
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
(define HEADERS `(,(row 'null '("Type" "Cost"))))
(define ROWS `(,(row 'inactive '("Ship" "$1000"))
               ,(row 'active '("Mine" "$200"))))