SRC_DIR = src
BUILD_DIR = build
METADATA = metadata.yaml
COVER_IMAGE = cover.jpg
BOOK_NAME = book
CHAPTERS = $(sort $(wildcard $(SRC_DIR)/*.md))

PANDOC_FLAGS = --standalone --metadata-file=$(METADATA)
EPUB_FLAGS = --epub-cover-image=$(COVER_IMAGE)
PDF_FLAGS = --include-before-body cover.tex --top-level-division=chapter -V documentclass=book -V classoption=oneside

.PHONY: all clean epub install-dependencies pdf

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

all: pdf epub

clean:
	@echo "Cleaning build directory..."
	rm -rf $(BUILD_DIR)

epub: $(CHAPTERS) $(METADATA) | $(BUILD_DIR)
	@echo "Generating EPUB..."
	pandoc $(CHAPTERS) -o $(BUILD_DIR)/$(BOOK_NAME).epub $(PANDOC_FLAGS) $(EPUB_FLAGS)

install-dependencies:
	@echo "Installing dependencies..."
	sudo apt-get update
	sudo apt-get install pandoc texlive qpdf

pdf: $(CHAPTERS) $(METADATA) | $(BUILD_DIR)
	@echo "Generating PDF..."
	pandoc $(CHAPTERS) -o $(BUILD_DIR)/$(BOOK_NAME)-draft.pdf $(PANDOC_FLAGS) $(PDF_FLAGS)
	qpdf --empty --pages $(BUILD_DIR)/$(BOOK_NAME)-draft.pdf 2,1,3-z -- $(BUILD_DIR)/$(BOOK_NAME).pdf
	rm $(BUILD_DIR)/$(BOOK_NAME)-draft.pdf
