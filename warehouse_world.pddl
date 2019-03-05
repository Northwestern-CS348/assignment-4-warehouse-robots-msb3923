(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
      :parameters (?lS - location ?lN - location ?r - robot)
      :precondition (and (at ?r ?lS) (no-robot ?lN) (connected ?lS ?lN))
      :effect (and (not (at ?r ?lS)) (not (no-robot ?lN)) (at ?r ?lN) (no-robot ?lS))
   )

   (:action robotMoveWithPallette
      :parameters (?lS - location ?lN - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?lS) (at ?p ?lS) (no-robot ?lN) (no-pallette ?lN) (connected ?lS ?lN))
      :effect (and (not (at ?p ?lS)) (not (at ?r ?lS)) (not (no-pallette ?lN)) (not (no-robot ?lN)) (at ?r ?lN) (at ?p ?lN) (no-pallette ?lS) (no-robot ?lS))
   )

   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?p - pallette ?o - order)
      :precondition (and (at ?p ?l) (contains ?p ?si) (packing-at ?s ?l) (orders ?o ?si) (ships ?s ?o) (not (includes ?s ?si)))
      :effect (and (not (contains ?p ?si)) (not (orders ?o ?si)) (includes ?s ?si))
   )

   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (packing-at ?s ?l) (started ?s) (not (complete ?s)) (ships ?s ?o))
      :effect (and (complete ?s) (available ?l))   
   )
)
