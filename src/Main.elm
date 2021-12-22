module Main exposing (..)

import Browser
import Config
import Css
import Css.Global
import Html.Styled as Html exposing (Html, div, text)
import Html.Styled.Attributes as Attr exposing (css)
import Tailwind.Utilities as Tw
import Task
import Time



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc
    , Cmd.batch
        [ Task.perform SetTime Time.now
        , Task.perform SetZone Time.here
        ]
    )



-- UPDATE


type Msg
    = SetTime Time.Posix
    | SetZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime newTime ->
            ( { model | time = newTime }, Cmd.none )

        SetZone newZone ->
            ( { model | zone = newZone }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 SetTime



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "New Tab"
    , body =
        [ Html.toUnstyled <|
            div []
                [ Css.Global.global Tw.globalStyles
                , Html.main_ [ css [ Tw.flex, Tw.flex_col, Tw.justify_center, Tw.items_center, Tw.gap_4, Tw.mt_5 ] ]
                    [ clock model
                    , shortcutList Config.shortcuts
                    , hackernews model
                    ]
                ]
        ]
    }



-- COMPONENTS


clock : Model -> Html Msg
clock model =
    let
        day =
            Time.toDay model.zone model.time
                |> String.fromInt
                |> (\x -> x ++ ".")

        weekday =
            Time.toWeekday model.zone model.time
                |> fromWeekday

        month =
            Time.toMonth model.zone model.time
                |> fromMonth

        hours =
            Time.toHour model.zone model.time
                |> String.fromInt
                |> String.padLeft 2 '0'

        minutes =
            Time.toMinute model.zone model.time
                |> String.fromInt
                |> String.padLeft 2 '0'

        seconds =
            Time.toSecond model.zone model.time
                |> String.fromInt
                |> String.padLeft 2 '0'
    in
    div [ css [ Tw.grid ] ]
        [ div []
            [ text <| String.join " " [ weekday, day, month ]
            ]
        , div []
            [ text <| String.join ":" [ hours, minutes, seconds ]
            ]
        ]


fromWeekday : Time.Weekday -> String
fromWeekday weekday =
    case weekday of
        Time.Mon ->
            "Mon"

        Time.Tue ->
            "Tue"

        Time.Wed ->
            "Wed"

        Time.Thu ->
            "Thu"

        Time.Fri ->
            "Fri"

        Time.Sat ->
            "Sat"

        Time.Sun ->
            "Sun"


fromMonth : Time.Month -> String
fromMonth month =
    case month of
        Time.Jan ->
            "Jan"

        Time.Feb ->
            "Feb"

        Time.Mar ->
            "Mar"

        Time.Apr ->
            "Apr"

        Time.May ->
            "May"

        Time.Jun ->
            "Jun"

        Time.Jul ->
            "Jul"

        Time.Aug ->
            "Aug"

        Time.Sep ->
            "Sep"

        Time.Oct ->
            "Oct"

        Time.Nov ->
            "Nov"

        Time.Dec ->
            "Dec"


shortcutList : Config.Shortcuts -> Html Msg
shortcutList shortcuts =
    div [ css [ Tw.grid ] ] <|
        List.map (\s -> Html.a [ Attr.href s.url ] [ text s.label ]) shortcuts


hackernews : Model -> Html Msg
hackernews model =
    div [] []
