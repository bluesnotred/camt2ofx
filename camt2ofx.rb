#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'date'
require 'builder'

file_name = ARGV[0]
exit if file_name.nil? || !File.file?(file_name)
camt = CamtParser::File.parse file_name
exit if camt.statements.count==0


@accountnr = camt.statements.first.account.iban
@bankname =  "YOUR BANK" 
@startdate =  camt.statements.first.from_date_time  
@enddate = camt.statements.first.to_date_time 

puts "Start: #{@startdate}"
puts "End: #{@enddate}"
puts "Account: #{@accountnr}"
puts "Bankname: #{@bankname}"

buffer = ""
    b = Builder::XmlMarkup.new(:target=>buffer, :indent=>2)
    b.instruct!

    b << "<?OFX OFXHEADER=\"200\" VERSION=\"200\" SECURITY=\"NONE\" OLDFILEUID=\"NONE\" NEWFILEUID=\"NONE\"?>\n"
    b.OFX {
      b.SIGNONMSGSRSV1 {
        b.SONRS {
          b.STATUS {
            b.CODE 0
            b.SEVERITY "INFO"
          }
          b.DTSERVER Date.today.strftime('%Y%m%d')
          b.LANGUAGE "ENG"
          b.FI {
            b.ORG @bankname
            b.FID @accountnr
          }
        }
      }

      b.BANKMSGSRSV1 {
        b.STMTTRNRS {
          b.TRNUID 0
          b.STATUS {
            b.CODE 0
            b.SEVERITY "INFO"
          }
          b.STMTRS {
            b.CURDEF "EUR"
            b.BANKACCTFROM {
              b.BANKID 123456789
              b.ACCTID @accountnr
              b.ACCTTYPE "CHECKING"
            }
            b.BANKTRANLIST {
              b.DTSTART @startdate.strftime('%Y%m%d')
              b.DTEND @enddate.strftime('%Y%m%d')

              camt.statements.each do |statement|
                statement.entries.each do |entry|
                  b.STMTTRN {
                    b.TINTYPE
                    b.DTPOSTED entry.booking_date.strftime('%Y%m%d')
                    b.TRNAMT (entry.amount*entry.sign).to_f
                    b.FITID entry.bank_reference
                    b.NAME entry.transactions[0].name
                    b.BANKACCTTO {
                      b.BANKID ""
                      b.ACCTID entry.transactions[0].iban
                      b.ACCTTYPE ""
                    }
                    b.MEMO entry.transactions[0].remittance_information
                  }
                end
              end
           }
         }
       }
     }
  }   

aFile = File.new(ARGV[0]+".ofx", "w")
aFile.write(buffer)
aFile.close

