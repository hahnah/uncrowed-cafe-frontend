module Main exposing (main)

import Browser
import Element exposing (layout)
import Html exposing (Html)



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ""
    , Cmd.none
    )



-- Msg


type Msg
    = Temp



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    layout
        []
    <|
        Element.text "Cafe!"
