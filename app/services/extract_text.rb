# app/services/extract_text.rb
class ExtractText
  def self.from_attachments(attachments, max_chars: 15_000)
    return "" if attachments.blank?
    parts = attachments.map { |att| extract(att) }.reject(&:blank?)
    parts.join("\n\n---\n\n")[0...max_chars]
  end

  def self.extract(att)
    ct = att.content_type
    data = att.download

    case ct
    when "text/plain", "text/markdown", "text/csv", "application/csv"
      data.force_encoding("UTF-8")
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
    require "pdf-reader"
    io = StringIO.new(binary)
    reader = PDF::Reader.new(io)
    reader.pages.map(&:text).join("\n")
  end

  def self.extract_docx(binary)
    require "docx"
    Tempfile.create(["upload", ".docx"]) do |f|
      f.binmode
      f.write(binary)
      f.flush
      doc = Docx::Document.open(f.path)
      doc.paragraphs.map(&:text).join("\n")
    end
  end
end
