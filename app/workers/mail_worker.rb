class MailWorker
  include Sidekiq::Worker

  def perform(pdf_text, email, mail_to, subject)

      kit = PDFKit.new(pdf_text)
      # Get an inline PDF
      pdf = kit.to_pdf

    if Rails.env.development?
      Pony.mail(
        :from => 'tester@localhost',
        :to => 'ajargans@gmail.com',
        :subject => "[Test] "+t('mail.subject'),
        :html_body => email,
        :attachments => {"RegistrationCard.pdf" => pdf},
        :body_part_header => { content_disposition: "inline" }
      )
    else
      Pony.mail(
        :to => mail_to,
        :subject => subject,
        :html_body => email,
        :attachments => {"RegistrationCard.pdf" => pdf},
        :body_part_header => { content_disposition: "inline" }
      )
    end
  end
end