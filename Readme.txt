

Code_for_match_feature:
FPP_Compare_MCP: Use the features with a length of 128 to calculate the Euclidean distance as similarity between each two pores, and save the compared pore indexs for the next step.
FPP_RANSAC: Use the RANSAC to refine coarse-corresponding pore pairs and save the fine-corresponding pore pair indexs for the next step.
FPP_MatchScore: Calculate the matchscores of the 3700 genuine pairs and 21756 imposter pairs and save it for the next step.
FPP_EER_Combine_TDSWR: Calculate the EER and combine the matchscore with the TDSWR.
FPP_Combine_Multi_Nets: Concatenate the features produced by different models.
FPP_DP_Area: Use the Minutiae locations to calculate the "Distinctive Pores" ROI for each fingerprint images.
FPP_Selected_DP_Code: Use the "Distinctive Pores" ROI to select "Distinctive Pores" features.
FPP_Selected_DP_Cord: Use the "Distinctive Pores" ROI to select "Distinctive Pores" cordinates.

