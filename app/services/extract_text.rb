class ExtractText
  def self.from_attachments(attachments, max_chars: 15_000)
    return "" if attachments.blank?
    parts = attachments.map { |att| extract(att) }.reject(&:blank?)
    parts.join("\n\n---\n\n")[0...max_chars]
  end

  def self.extract(att)
    ct   = att.content_type
    data = att.download

    case ct
    when "text/plain", "text/markdown", "text/csv", "application/csv"
      data.to_s.force_encoding("UTF-8")
    when "application/pdf"
      extract_pdf(data)
    when "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      extract_docx(data)
    else
      "Unsupported file (#{att.filename}, #{ct})"
    end
  rescue => e
    "Failed to read #{att.filename}: #{e.class} - #{e.message}"
  end

  def self.extract_pdf(binary)
    begin
      require "pdf-reader"
    rescue LoadError
      return "PDF parsing unavailable: install the 'pdf-reader' gem."
    end
    io = StringIO.new(binary)
    reader = PDF::Reader.new(io)
    reader.pages.map(&:text).join("\n")
  rescue => e
    "Failed to parse PDF: #{e.class} - #{e.message}"
  end

  def self.extract_docx(binary)
    begin
      require "docx"
    rescue LoadError
      return "DOCX parsing unavailable: install the 'docx' gem."
    end
    Tempfile.create(["upload", ".docx"]) do |f|
      f.binmode; f.write(binary); f.flush
      doc = Docx::Document.open(f.path)
      doc.paragraphs.map(&:text).join("\n")
    end
  rescue => e
    "Failed to parse DOCX: #{e.class} - #{e.message}"
  end
end
