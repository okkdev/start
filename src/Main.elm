module Main exposing (..)

import Browser
import Css
import Css.Global
import Html.Styled as Html exposing (button, div, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import Tailwind.Utilities as Tw



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
    Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0
    , Cmd.none
    )



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( model + 1, Cmd.none )

        Decrement ->
            ( model - 1, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Elm Site Template"
    , body =
        [ Html.toUnstyled <|
            div []
                [ Css.Global.global Tw.globalStyles
                , Html.main_ [ css [ Tw.flex, Tw.justify_center, Tw.items_center, Tw.gap_4, Tw.mt_5 ] ]
                    [ button
                        [ onClick Decrement
                        , css
                            [ Tw.bg_indigo_500
                            , Tw.text_white
                            , Tw.text_xl
                            , Tw.font_bold
                            , Tw.py_2
                            , Tw.px_4
                            , Tw.rounded
                            , Css.hover [ Tw.bg_indigo_700 ]
                            ]
                        ]
                        [ text "-" ]
                    , div [ css [ Tw.text_4xl, Tw.font_bold ] ] [ text (String.fromInt model) ]
                    , button
                        [ onClick Increment
                        , css
                            [ Tw.bg_indigo_500
                            , Tw.text_white
                            , Tw.text_xl
                            , Tw.font_bold
                            , Tw.py_2
                            , Tw.px_4
                            , Tw.rounded
                            , Css.hover [ Tw.bg_indigo_700 ]
                            ]
                        ]
                        [ text "+" ]
                    ]
                ]
        ]
    }
