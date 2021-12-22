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

    -- , weekday : Time.Weekday
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
                , Html.main_ [ css [ Tw.flex, Tw.justify_center, Tw.items_center, Tw.gap_4, Tw.mt_5 ] ]
                    [ clock model
                    , bookmarkList Config.bookmarks
                    ]
                ]
        ]
    }



-- COMPONENTS


clock : Model -> Html Msg
clock model =
    let
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
    div []
        [ text <| String.join ":" [ hours, minutes, seconds ]
        ]


bookmarkList : Config.Bookmarks -> Html Msg
bookmarkList bookmarks =
    div [] <|
        List.map (\b -> Html.a [ Attr.href b.url ] [ text b.label ]) bookmarks
