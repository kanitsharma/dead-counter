module Main exposing (main)

import Html 
import Element exposing (text, html, alpha,  fill, width, centerX, paddingXY, rgb255, above)
import Element.Font as Font
import Element.Background exposing (color, image)

main = 
    Element.layout [image "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/10-full.jpg"] 
    columns

columns = Element.column [ Font.family
            [ Font.typeface "marston"
            , Font.sansSerif
            ], Font.size 45, alpha 0.3, Font.color (rgb255 255 255 255), color (rgb255 0 0 0), width fill, paddingXY 0 20 ]
    [ 
        Element.row [ centerX ] [ text "Red Dead Counter" ]
    ]