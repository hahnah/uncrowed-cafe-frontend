port module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, column, el, fill, height, layout, padding, row, text, width, wrappedRow)
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Url



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
    { location : Maybe Location
    , searchResult : SearchResult
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { location = Nothing
      , searchResult = SearchResult "None" []
      }
    , Cmd.none
    )


type alias Location =
    { latitude : Float
    , longitude : Float
    }


type alias SearchResult =
    { status : String
    , cafes : List Cafe
    }


type alias Cafe =
    { address : String
    , location : Location
    , id : String
    , name : String
    , congestionPercentage : Int
    , rating : Float
    }



-- Msg


type Msg
    = ClickSearchButton
    | GetLocation String
    | GotCafeSearchResult (Result Http.Error String)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveLocation GetLocation


port receiveLocation : (String -> msg) -> Sub msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickSearchButton ->
            ( model, requestLocation () )

        GetLocation jsonString ->
            let
                decodedLocation : Result Decode.Error Location
                decodedLocation =
                    Decode.decodeString locationDecoder jsonString

                maybeLocation : Maybe Location
                maybeLocation =
                    case decodedLocation of
                        Ok location_ ->
                            Just location_

                        Err _ ->
                            Nothing

                command : Cmd Msg
                command =
                    case maybeLocation of
                        Just location_ ->
                            let
                                requestUrlForCafeSearch : Url.Url
                                requestUrlForCafeSearch =
                                    { protocol = Url.Https
                                    , host = "us-central1-uncrowded-cafe-1568290675412.cloudfunctions.net"
                                    , port_ = Nothing
                                    , path = "/function-temp"
                                    , query = Nothing
                                    , fragment = Nothing
                                    }

                                requestBodyForCafeSearch : Http.Body
                                requestBodyForCafeSearch =
                                    [ ( "latitude", Encode.float location_.latitude )
                                    , ( "longitude", Encode.float location_.longitude )
                                    ]
                                        |> Encode.object
                                        |> Http.jsonBody
                            in
                            Http.request
                                { method = "POST"
                                , headers = []
                                , url = Url.toString requestUrlForCafeSearch
                                , body = requestBodyForCafeSearch
                                , expect = Http.expectString GotCafeSearchResult
                                , timeout = Just 20000
                                , tracker = Nothing
                                }

                        Nothing ->
                            Cmd.none
            in
            ( { model | location = maybeLocation }
            , command
            )

        GotCafeSearchResult result ->
            case result of
                Ok jsonString ->
                    let
                        decodedSearchResult : Result Decode.Error SearchResult
                        decodedSearchResult =
                            Decode.decodeString searchResultDecoder jsonString
                    in
                    case decodedSearchResult of
                        Ok searchResult_ ->
                            ( { model | searchResult = searchResult_ }
                            , Cmd.none
                            )

                        Err _ ->
                            ( { model | searchResult = SearchResult "ERROR" [] }
                            , Cmd.none
                            )

                Err _ ->
                    ( { model | searchResult = SearchResult "ERROR" [] }
                    , Cmd.none
                    )


port requestLocation : () -> Cmd msg


locationDecoder : Decoder Location
locationDecoder =
    Decode.map2 Location
        (Decode.at [ "location", "latitude" ] Decode.float)
        (Decode.at [ "location", "longitude" ] Decode.float)


searchResultDecoder : Decoder SearchResult
searchResultDecoder =
    Decode.map2 SearchResult
        (Decode.field "status" Decode.string)
        (Decode.field "search_result" <| Decode.list cafeDecoder)


cafeDecoder : Decoder Cafe
cafeDecoder =
    Decode.map6 Cafe
        (Decode.field "address" Decode.string)
        (Decode.field "coordinates" coordinatsDecoder)
        (Decode.field "id" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "popularity" Decode.int)
        (Decode.field "rating" Decode.float)


coordinatsDecoder : Decoder Location
coordinatsDecoder =
    Decode.map2 Location
        (Decode.field "lat" Decode.float)
        (Decode.field "lng" Decode.float)



-- VIEW


view : Model -> Html Msg
view model =
    layout
        [ width fill
        ]
    <|
        column
            [ width fill
            , centerX
            ]
            [ el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewTitle
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewLogo
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewDescription
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
                viewSearchButton
            , el
                [ width fill
                , centerX
                , centerY
                , padding 30
                , Border.width 1
                ]
              <|
                viewSearchResult model.searchResult
            , el
                [ width fill
                , centerX
                , centerY
                , padding 4
                , Border.width 1
                ]
                viewFooter
            ]


viewTitle : Element Msg
viewTitle =
    el [ centerX ] <|
        text "Title"


viewLogo : Element Msg
viewLogo =
    el
        [ centerX ]
    <|
        text "Logo"


viewDescription : Element Msg
viewDescription =
    el [ centerX ] <|
        text "Description"


viewSearchButton : Element Msg
viewSearchButton =
    el [ centerX ] <|
        Input.button
            [ Border.width 1
            , Border.rounded 15
            , Element.paddingXY 10 4
            ]
            { onPress = Just ClickSearchButton
            , label = text "Search Cafes Near You"
            }


viewSearchResult : SearchResult -> Element Msg
viewSearchResult searchResult =
    wrappedRow
        []
    <|
        List.map (el [ padding 10 ] << viewCafe) searchResult.cafes


viewCafe : Cafe -> Element Msg
viewCafe cafe =
    row
        [ Border.width 1 ]
        [ text "Thumbnail"
        , column
            []
            [ el [] <| text cafe.name
            , el [] <| text <| String.concat [ "Congestion Rate : ", String.fromInt cafe.congestionPercentage, "%" ]
            , el [] <| text <| String.concat [ "Stars : ", String.fromFloat cafe.rating ]
            , el [] <| text "Distance : 100M"
            , el [] <| text "View On Google Map"
            ]
        ]


viewFooter : Element Msg
viewFooter =
    el [ centerX ] <|
        text "Footer"
