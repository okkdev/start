port module Main exposing (..)

import Browser
import Config
import Css
import Css.Global
import Html.Styled as Html exposing (Html, div, text)
import Html.Styled.Attributes as Attr exposing (css)
import Http
import Json.Decode as D exposing (Decoder)
import List
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
import Task
import Time
import Url



-- MAIN


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- PORTS


port themeListener : (String -> msg) -> Sub msg



-- MODEL


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , news : HNews
    , theme : Config.Theme
    }


type alias Flags =
    { time : Int
    , theme : String
    }


type HNews
    = Loading
    | Failure
    | Success HNPosts


type alias HNPosts =
    List HNPost


type alias HNPost =
    { id : Int
    , title : String
    , url : String
    , comment_count : Int
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model (Time.millisToPosix flags.time) Time.utc Loading Config.defaultTheme
    , Cmd.batch
        [ Task.perform SetZone Time.here
        , Task.perform identity <| Task.succeed (ChangeTheme flags.theme)
        , Http.get
            { url = "https://api.hackerwebapp.com/news"
            , expect = Http.expectJson GotNews newsDecoder
            }
        ]
    )



-- UPDATE


type Msg
    = SetTime Time.Posix
    | SetZone Time.Zone
    | GotNews (Result Http.Error HNPosts)
    | ChangeTheme String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTime newTime ->
            ( { model | time = newTime }, Cmd.none )

        SetZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        GotNews result ->
            case result of
                Ok posts ->
                    ( { model | news = Success posts }, Cmd.none )

                Err _ ->
                    ( { model | news = Failure }, Cmd.none )

        ChangeTheme theme ->
            case theme of
                "dark" ->
                    ( { model | theme = Config.Dark }, Cmd.none )

                "light" ->
                    ( { model | theme = Config.Light }, Cmd.none )

                _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every 1000 SetTime
        , themeListener ChangeTheme
        ]



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "New Tab"
    , body =
        [ Html.toUnstyled <|
            div []
                [ Css.Global.global Tw.globalStyles
                , Css.Global.global
                    [ Css.Global.typeSelector "html"
                        (if isDark model.theme then
                            [ Css.backgroundColor (Css.hex "232027")
                            , Css.color (Css.hex "fef9f9")
                            ]

                         else
                            [ Css.backgroundColor (Css.hex "fef9f9")
                            , Css.color (Css.hex "232027")
                            ]
                        )
                    ]
                , Html.main_
                    [ css
                        [ Tw.leading_5
                        , Tw.text_base
                        , Tw.flex
                        , Tw.flex_col
                        , Tw.justify_center
                        , Tw.items_center
                        , Tw.h_screen
                        , Tw.max_w_full
                        , Tw.gap_8
                        ]
                    ]
                    [ clock model

                    -- , shortcutList Config.shortcuts
                    , hackernews model.news
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
        [ div [ css [ Tw.text_5xl, Tw.font_black, Tw.tabular_nums ] ]
            [ text <| String.join ":" [ hours, minutes, seconds ]
            ]
        , div [ css [ Tw.text_center ] ]
            [ text <| String.join " " [ weekday, day, month ]
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
shortcutList =
    div [ css [ Tw.grid, Tw.grid_flow_col, Tw.auto_cols_auto, Tw.gap_5 ] ]
        << List.map (\s -> Html.a [ Attr.href s.url ] [ text s.label ])


hackernews : HNews -> Html Msg
hackernews news =
    case news of
        Success posts ->
            div [ css [ Tw.grid, Tw.gap_2 ] ] <|
                List.map
                    (\p ->
                        div [ css [ Tw.hidden, Breakpoints.sm [ Tw.grid ] ] ]
                            [ Html.a [ Attr.href (checkHnUrl p.url), css [ Tw.flex, Tw.items_baseline, Tw.gap_1, Tw.min_w_0 ] ]
                                [ div [ css [ Tw.truncate ] ] [ text p.title ]
                                , div [ css [ Tw.text_xs, Tw.hidden, Breakpoints.md [ Tw.block ] ] ] [ text <| getHost p.url ]
                                ]
                            , div []
                                [ Html.a
                                    [ Attr.href <| "https://news.ycombinator.com/item?id=" ++ String.fromInt p.id
                                    , css [ Tw.text_xs ]
                                    ]
                                    [ text <|
                                        (++) (String.fromInt p.comment_count) <|
                                            if p.comment_count == 1 then
                                                " comment"

                                            else
                                                " comments"
                                    ]
                                ]
                            ]
                    )
                <|
                    List.take 10 posts

        Loading ->
            text "Loading..."

        _ ->
            text ""


getHost : String -> String
getHost s =
    case Url.fromString s of
        Just url ->
            url.host

        _ ->
            if String.startsWith "item?id" s then
                "self"

            else
                s


checkHnUrl : String -> String
checkHnUrl url =
    if String.startsWith "item?id" url then
        "https://news.ycombinator.com/" ++ url

    else
        url


newsDecoder : Decoder HNPosts
newsDecoder =
    D.list postDecoder


postDecoder : Decoder HNPost
postDecoder =
    D.map4 HNPost
        (D.field "id" D.int)
        (D.field "title" D.string)
        (D.field "url" D.string)
        (D.field "comments_count" D.int)


isDark : Config.Theme -> Bool
isDark =
    (==) Config.Dark
