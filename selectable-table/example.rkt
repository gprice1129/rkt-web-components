#lang web-server/insta

(require "selectable-table.rkt")

(define (start req)
    (response/xexpr
        `(html
            (head (title "Selectable Table Example")
                  ,stylesheet)
            (body
                ,(render-selectable-table HEADERS ROWS)
                (form ((id "query")))
                ,jquery
                ,selectable-table-js 
                ))))

(static-files-path "htdocs")
(define stylesheet
   '(link ((rel "stylesheet") (href "/style.css") (type "text/css"))))
(define jquery
    '(script ((src "/jquery-3.5.1.js"))))
(define selectable-table-js 
    '(script ((src "/selectable-table.js"))))

;;; static data
(define HEADERS `(,(row 'null '("Type" "Cost"))))
(define ROWS `(,(row 'inactive '("Ship" "$1000"))
               ,(row 'active '("Mine" "$200"))))