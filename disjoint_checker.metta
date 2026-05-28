; Disjoint Set Checker

(= (shares? $A $B)
   (let $shared (intersection-atom $A $B) (> (size-atom $shared) 0)))

;(> (size-atom (intersection-atom $A $B)) 0)

(= (list-union $A $B)
   (unique-atom (append $A $B)))

(= (same-set? $A $B)
   (and (== (size-atom $A) (size-atom $B))
        (== () (collapse
                 (let $x (superpose $A)
                   (if (is-member $x $B) (empty) $x))))))

(= (grow $elems $tuples $acc)
   (if (== $tuples ())
       $acc
       (let ($T $rest) (decons-atom $tuples)
         (if (shares? $T $elems)
             (grow $elems $rest (list-union $T $acc))
             (grow $elems $rest $acc)))))


(= (close $elems $tuples)
   (let $next (grow $elems $tuples $elems)
     (if (same-set? $next $elems)
         $elems
         (close $next $tuples))))

(= (all-covered? $tuples $pool)
   (if (== $tuples ())
       True
       (let ($T $rest) (decons-atom $tuples)
         (if (shares? $T $pool)
             (all-covered? $rest $pool)
             False))))

(= (all-reachable? $tuples)
   (let* (($first (car-atom $tuples))
          ($pool  (close $first $tuples)))
     (all-covered? $tuples $pool)))

(= (is-disjoint? $tuples)
   (not (all-reachable? $tuples)))



; Two conjuncts are connected if they share a variable name.

!(test (is-disjoint? ((Age $State 3) (State Income) (Hobby $City 3))) True)

;!(test (is-disjoint? ((Age State) (State City) (City Zip))) False)
