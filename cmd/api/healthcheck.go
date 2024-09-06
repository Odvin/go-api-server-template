package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {
	js := `{"status": "available", "environment": %q, "version": %q}`
	js = fmt.Sprintf(js, app.config.env, version)

	w.Header().Set("Content-Type", "application/json")

	var response bytes.Buffer
	json.Indent(&response, append([]byte(js), '\n'), " ", "\t")

	w.Write(response.Bytes())
}
