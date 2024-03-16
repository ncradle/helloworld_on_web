module HelloHttp exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Http exposing (Error(..))


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { text : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model "", Cmd.none )


type Msg
    = HttpRequest
    | HttpResult (Result Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HttpRequest ->
            ( model
            , Http.get
                { url = "http://localhost:5000"
                , expect = Http.expectString HttpResult
                }
            )

        HttpResult result ->
            case result of
                Ok text ->
                    ( { model | text = text }, Cmd.none )

                Err err ->
                    case err of
                        BadUrl badurl ->
                            ( { model | text = "Bad url :" ++ badurl }, Cmd.none )

                        Timeout ->
                            ( { model | text = "Timeout" }, Cmd.none )

                        NetworkError ->
                            ( { model | text = "Network error" }, Cmd.none )

                        BadStatus status ->
                            ( { model | text = "Bad status : " ++ String.fromInt status }, Cmd.none )

                        BadBody badBody ->
                            ( { model | text = "Bad body : " ++ badBody }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick HttpRequest ] [ text "get" ]
        , div [] [ text model.text ]
        ]
