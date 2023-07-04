package main

import (
	"fmt"
	"html/template"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

type Artifact struct {
	Project string
	Build int
	Path template.URL
}

func renderIndex(w http.ResponseWriter) {
	artifacts := []Artifact{}
	// Find all manifest property list files.
	MANIFEST_PATTERN := regexp.MustCompile(`^/data/(\w+)/builds/(\d+)/archive/(.+)/manifest.plist$`)
	err := filepath.WalkDir("/data/", func(path string, info fs.DirEntry, err error) error {
		if !strings.HasSuffix(path, "/manifest.plist") {
			return nil
		}
		// Extract project and build number submatches.
		if MANIFEST_PATTERN.MatchString(path) {
			match := MANIFEST_PATTERN.FindStringSubmatch(path)
			build, _ := strconv.Atoi(match[2])
			artifacts = append(artifacts, Artifact{match[1], build, template.URL(match[3])})
		}
		return nil;
	});
	if err != nil {
		log.Printf("%d %v", http.StatusInternalServerError, err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Sort artifacts in reverse by build number
	sort.Slice(artifacts, func(i, j int) bool {
		return artifacts[i].Build > artifacts[j].Build
	})

	// Render HTML with links refering to manifest files.
	tmpl, err := template.ParseFiles("/static/index.tmpl")
	if err != nil {
		log.Printf("%d %v", http.StatusInternalServerError, err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	err = tmpl.Execute(w, artifacts)
	if err != nil {
		log.Printf("%d %v", http.StatusInternalServerError, err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	log.Println(http.StatusOK)
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	log.Printf("%s %s", r.Method, r.URL.Path)
	// TODO: Support the HEAD method
	if r.Method != "GET" {
		log.Println(http.StatusMethodNotAllowed)
		w.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	// Find all property list and IPA files
	files := map[string]bool{}
	err := filepath.WalkDir("/data/", func(path string, info fs.DirEntry, err error) error {
		if filepath.Ext(path) != ".plist" && filepath.Ext(path) != ".ipa" {
			return nil
		}
		files[path] = true
		return nil;
	});
	if err != nil {
		log.Println(http.StatusInternalServerError)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	// Respond to requests based on request path
	switch r.URL.Path {
	case "/index.html", "/":
		renderIndex(w)
	default:
		path := filepath.Join("/data/", r.URL.Path)
		if files[path] {
			log.Println(http.StatusOK)
			http.ServeFile(w, r, path)
			return
		}
		log.Println(http.StatusNotFound)
		w.WriteHeader(http.StatusNotFound)
	}
}

func main() {
	// Set HTTP listening port with HTTP_PORT environment variable
	port, ok := os.LookupEnv("HTTP_PORT")
	if !ok { panic("ERROR: No HTTP_PORT environment variable set.") }

	// Setup request handlers
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/static/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, r.URL.Path)
	})
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
