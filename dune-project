(lang dune 3.10)
(name keystone)

(generate_opam_files)

(source (github rems-project/ocaml-keystone-engine))
(maintainers "dk505@cl.cam.ac.uk")

(package
 (name keystone)
 (synopsis "Bindings to the Keystone Engine assembler")
 (description "https://www.keystone-engine.org")
 (depends (ocaml (>= 4.10.0))))
