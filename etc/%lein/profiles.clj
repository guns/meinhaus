
;; ###
;;  ###             #                 #
;;   ##            ###               ###
;;   ##             #                 #
;;   ##
;;   ##      /##  ###   ###  /###   ###   ###  /###     /###      /##  ###  /###
;;   ##     / ###  ###   ###/ #### / ###   ###/ #### / /  ###  / / ###  ###/ #### /
;;   ##    /   ###  ##    ##   ###/   ##    ##   ###/ /    ###/ /   ###  ##   ###/
;;   ##   ##    ### ##    ##    ##    ##    ##    ## ##     ## ##    ### ##    ##
;;   ##   ########  ##    ##    ##    ##    ##    ## ##     ## ########  ##    ##
;;   ##   #######   ##    ##    ##    ##    ##    ## ##     ## #######   ##    ##
;;   ##   ##        ##    ##    ##    ##    ##    ## ##     ## ##        ##    ##
;;   ##   ####    / ##    ##    ##    ##    ##    ## ##     ## ####    / ##    ##
;;   ### / ######/  ### / ###   ###   ### / ###   ### ########  ######/  ###   ###
;;    ##/   #####    ##/   ###   ###   ##/   ###   ###  ### ###  #####    ###   ###
;;                                                           ###
;;                                                     ####   ###
;;        guns <self@sungpae.com>                    /######  /#
;;                                                  /     ###/

{:user {:plugins [[lein-exec "0.3.1"]
                  [lein-kibit "0.0.8"]
                  [lein-ancient "0.4.4"]]
        :dependencies [[org.clojure/tools.trace "0.7.5"]
                       [slamhound "1.4.0"]]
        :aliases {"RUN" ["trampoline" "run"]
                  "REPL" ["trampoline" "repl" ":headless"]}
        :signing {:gpg-key "0x24142BFA974864C311D3AED537BD7E31C8C835A2"}
        :repl-options
        {:init
         (do
           ;;
           ;; Swap javadoc URLs to local versions
           ;;

           (require 'clojure.java.javadoc)

           (let [core-url clojure.java.javadoc/*core-java-api*
                 local-url "http://api/jdk7/api/"]
             (dosync
               (alter clojure.java.javadoc/*remote-javadocs*
                      #(reduce
                         (fn [m [pre url]]
                           (assoc m pre (if (= url core-url)
                                          local-url
                                          url)))
                         {} %)))
             (alter-var-root #'clojure.java.javadoc/*core-java-api*
                             (constantly local-url)))

           ;;
           ;; Add debugging macros
           ;;

           (require 'clojure.pprint)

           (defmacro debug
             ([& xs]
              `(do (clojure.pprint/pprint
                     (zipmap '~(reverse xs) [~@(reverse xs)]))
                   ~(last xs))))

           (defmacro dump-locals []
             `(clojure.pprint/pprint
                ~(into {} (map (fn [l] [`'~l l]) (reverse (keys &env))))))

           (defmacro benchmark
             ([expr] `(benchmark 10 ~expr))
             ([n expr] `(time (dotimes [_# ~n] ~expr))))

           (defmacro trace
             ([expr] `(trace *ns* ~expr))
             ([nspace expr]
              (require 'clojure.tools.trace)
              `(try (clojure.tools.trace/trace-ns ~nspace)
                    ~expr
                    (finally (clojure.tools.trace/untrace-ns ~nspace))))))}}}
