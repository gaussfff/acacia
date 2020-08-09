(asdf:defsystem "acacia"
    :class :package-inferred-system
    :defsystem-depends-on (:asdf-package-system)
    :description "Parser generator for translators in Common Lisp"
    :version "0.0.1"
    :author "Sokolovskyi Bohdan"
    :depends-on ("acacia/core"
                 "trivia"))
