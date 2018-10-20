module Main exposing (main)

import Browser
import Element exposing (above, alpha, centerX, centerY, fill, height, html, paddingXY, rgb255, text, width)
import Element.Background exposing (color, image)
import Element.Font as Font
import Html exposing (Html)
import List
import Maybe
import Random
import Task
import Time



-- MODEL

defaultSlide : String
defaultSlide = "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/19-full.jpg"

slides : List String
slides =
    [ "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/23-full.jpg", "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/21-full.jpg", "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/15-full.jpg", "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/9-full.jpg", "https://www.rockstargames.com/reddeadredemption2/rockstar_games/r_d_r2_core/img/screenshots/12-full.jpg" ]

slideIndexSwitcher ind = if ind == (List.length slides) then 0 else ind

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , currentDate : Date
    , targetDate : Date
    , currentWallpaper : Int
    , wallpapers : List String
    }


type Date
    = Date Int Int Int Int


init : () -> ( Model, Cmd Msg )
init _ =
    let
        time =
            Time.millisToPosix 0

        zone =
            Time.utc
    in
    ( Model zone time (createDate time zone) (Date 26 24 60 60) 0 slides
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | ChangeWallpaper Time.Posix


createDate : Time.Posix -> Time.Zone -> Date
createDate time zone =
    let
        hour =
            Time.toHour zone time

        minute =
            Time.toMinute zone time

        second =
            Time.toSecond zone time

        day =
            Time.toDay zone time
    in
    Date day hour minute second


toPaddedString : Int -> String
toPaddedString number =
    if number < 9 then
        "0" ++ String.fromInt number

    else
        String.fromInt number


getDiffDate : Date -> Date -> Date
getDiffDate (Date cday chour cminute csecond) (Date tday thour tminute tsecond) =
    Date (tday - cday) (thour - chour) (tminute - cminute) (tsecond - csecond)


getDateString : Date -> String
getDateString (Date day hour minute second) =
    toPaddedString day ++ " : " ++ toPaddedString hour ++ " : " ++ toPaddedString minute ++ " : " ++ toPaddedString second


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | currentDate = createDate newTime model.zone }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Task.perform Tick Time.now
            )
            
        ChangeWallpaper _ ->
            ( { model | currentWallpaper = slideIndexSwitcher model.currentWallpaper + 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick
        , Time.every 5000 ChangeWallpaper
        ]


view : Model -> Html Msg
view model =
    Element.layout
        [ image <| Maybe.withDefault defaultSlide <| List.head << List.drop model.currentWallpaper <| model.wallpapers
        ]
    <|
        Element.column
            [ color (rgb255 0 0 0), alpha 0.7, Font.color (rgb255 255 255 255), width fill, height fill, Font.family [ Font.typeface "marston", Font.sansSerif ], Font.size 105 ]
            [ Element.column
                [ centerX, centerY ]
                [ Element.row [] [ text "Red Dead Countdown" ]
                , Element.row [ centerX ] [ text <| getDateString <| getDiffDate model.currentDate model.targetDate ]
                ]
            ]



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
