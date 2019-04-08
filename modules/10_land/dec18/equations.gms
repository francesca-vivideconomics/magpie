*** |  (C) 2008-2018 Potsdam Institute for Climate Impact Research (PIK),
*** |  authors, and contributors see AUTHORS file
*** |  This file is part of MAgPIE and licensed under GNU AGPL Version 3
*** |  or later. See LICENSE file or go to http://www.gnu.org/licenses/
*** |  Contact: magpie@pik-potsdam.de

*' @equations
*' This realization defines the total amount of land to be constant over time.

 q10_land(j2) ..
		sum(land, vm_land(j2,land)) =e= sum(land, pm_land_start(j2,land));

*' The following 3 equations describe a land transition matrix.

 q10_transition_matrix(j2) ..
	sum((land_from10,land_to10), v10_lu_transitions(j2,land_from10,land_to10)) =e=
	sum(land, pm_land_start(j2,land));

 q10_transition_to(j2,land_to10) ..
	sum(land_from10, v10_lu_transitions(j2,land_from10,land_to10)) =e=
	vm_land(j2,land_to10);

 q10_transition_from(j2,land_from10) ..
	sum(land_to10, v10_lu_transitions(j2,land_from10,land_to10)) =e=
	pcm_land(j2,land_from10);

*' The following two equations calculate land expansion and land contraction based
*' on the above land transition matrix.

 q10_landexpansion(j2,land_to10) ..
        vm_landexpansion(j2,land_to10) =e=
        sum(land_from10$(not sameas(land_from10,land_to10)),
        v10_lu_transitions(j2,land_from10,land_to10));

 q10_landreduction(j2,land_from10) ..
        vm_landreduction(j2,land_from10) =e=
        sum(land_to10$(not sameas(land_from10,land_to10)),
        v10_lu_transitions(j2,land_from10,land_to10));

q10_croplandreduction(j2,land_to10) ..
               vm_croplandreduction(j2,land_to10) =e=
               v10_lu_transitions(j2,"crop",land_to10);

q10_croplandexpansion(j2,land_from10) ..
               vm_croplandexpansion(j2,land_from10) =e=
               v10_lu_transitions(j2,land_from10,"crop");

q10_croplandreduction(j2,land_to10) ..
                              vm_croplandchange(j2,land_to10) =e=
                              v10_lu_transitions(j2,"crop",land_to10);

*' Small costs of 1 $ per ha on gross land-use change avoid unrealistic patterns in the land transition matrix

 q10_cost(j2) ..
        vm_cost_land_transition(j2) =e=
        sum(land, vm_landexpansion(j2,land) + vm_landreduction(j2,land)) * 1;

*' The gross changes in land are calculated based on land expansion, land
*' contraction and land changes from within the modules [35_natveg]
*' and [32_forestry]:

 q10_landdiff ..
		vm_landdiff =e= sum((j2,land), vm_landexpansion(j2,land)
                                 + vm_landreduction(j2,land))
                                 + vm_landdiff_natveg
                                 + vm_landdiff_forestry;
