import Foundation

/*:
Textual representations of an URL instance
 */

let urlString = "https://www.example.com:8080/path/to/endpoint?key=value"

let url = URL(string: urlString)!

print(urlString)
print(url.formatted())

print()
print("- FormatStyle")
let urlFormatStyle = URL.FormatStyle(scheme: .never,
                                     user: .never,
                                     password: .never,
                                     host: .always,
                                     port: .never,
                                     path: .always,
                                     query: .never,
                                     fragment: .never)
print(urlFormatStyle.format(url))

print()
print("- formatted")

let urlFormatted = url.formatted(.url
    .scheme(.never)
    .host(.always)
    .port(.never)
    .path(.always)
    .query(.never))
print(urlFormatted)
