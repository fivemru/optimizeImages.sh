# Optimize jpeg images

The bash script, which processes `jpeg` files via [djpeg](http://jpegclub.org/djpeg/) and [cjpeg](http://jpegclub.org/cjpeg/).

## Requirements

The `cjpeg` and the `djpeg` available globally:

1. Download [jpg9cexe.zip](http://sylvana.net/jpeg-bin/jpg9cexe.zip)
2. Extract to `./jpg9cexe ` directory
3. Add `./jpg9cexe` directory to `PATH` Environment Variable


## Usage

```bash
$ optimizeImages.sh

Usage: optimizeImages.sh [options] files
Example: optimizeImages.sh -v -o ./out *.jpg

Options:
        -v verbose
        -q Quality 0..100 (default=90)
        -o Output dir (default=./out)
        -p Postfix output filename (default='')
```