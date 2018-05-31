#encoding=utf-8

=begin
** Created: 2017/12/20
**      by: 金山软件--钟成
** Modified: 2018/01/18
**      by: 金山软件--tmtony(王宇虹)
**
** Description:邮件处理模块
=end


require 'net/smtp'

module SalaryMailPlugin

  class KsSmtp

    Boundary      = '--------------------'

    def initialize(host, port, sender, password, receiver, subject, body, attachments)
      @host = host.strip
      @port = port.strip
      @sender = sender.strip
      @password = password.strip
      @receiver = receiver.strip
      @subject = subject.strip
      @body = body
      @attachments = attachments

    end

    def sendEmail
      header =<<EOF
From: #{@sender}
To: #{@receiver}
Subject: =?utf-8?B?#{[@subject].pack("m")} ?=
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{Boundary}

EOF

      body =<<EOF
--#{Boundary}
Content-Type: text/html; charset=utf-8;

#{@body}


EOF

      atts = ''
      @attachments.each {|att|
        filecontent = File.binread(att)
        p 'attachname:'+att.to_s
        encodecontent = [filecontent].pack("m")
        atts +=<<EOF
--#{Boundary}
Content-Type: application/octet-stream; charset=utf-8;
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="#{File.basename(att)}"

#{encodecontent}
EOF
      }

      ends =<<EOF
--#{Boundary}--
.
EOF

      mailContent =  header + body + atts + ends

      Net::SMTP::start(@host, @port, 'localhost', @sender, @password) do |smtp|
        #smtp.open_timeout=15
        smtp.read_timeout=15
        #这个设置太短容易出现net:readtimeout出错
        smtp.sendmail(mailContent, @sender, @receiver)
      end
    end

  end
end