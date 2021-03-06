class SnowEmergencyController < ApplicationController
  # assumption: if our mailbox has a mail with "Snow emergency" in the 
  # subject, which was sent in the past 24 hours, then a snow emergency is 
  # in effect.
  def index
    require 'net/imap'

    ret = false

    imap = Net::IMAP.new('imap.gmail.com',  993, true )
    imap.login('canhazparking', 'yesIcanz!');
    imap.select('INBOX')
    imap.search(["SUBJECT", "Snow emergency", "SENTSINCE", (Time.now - 1).strftime("%d-%b-%Y")]).each do |msgid|
      ret = true
      break
    end

    imap.logout()

    render :json => {:value => ret}
  end
end
