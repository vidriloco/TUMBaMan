TUM Manager
=========

TUM Manager is the backend for the Pumabus real-time platform as well as a web frontend for managing it's vehicle, line and stops data.

Technologies
-----------

This web application currently uses the following technologies:

* [Ruby on Rails] (version 4) - A web development framework based on Ruby 
* [Postgis] - A geospatial library atop PostgreSQL

Database structure
-----------

The database structure represents the following models:

* `Transport` - It represents a transportation agency, on this case, the *Pumabus* agency. It may have many lines.
* `Line` - Represents a service route. It may have many stations, vehicles and paths. Belongs to a Transport object. 
* `Station` - Represents a station on a line. It belongs to a line.
* `Path` - Represents a coordinate vector for the line route visualization on a map. It belongs to a line.
* `Vehicle` - Represents a vehicle on a given line. It may have many instants and belong to one line.
* `Instant` - Represents a measurement instant calculated from the GPS installed on a given vehicle. It belongs to a vehicle.
             
Current status
-----------

At this time, the application can only be useful for management of the Pumabus related data. In the forecoming paragraphs there are provided instructions on how the backend functionality should be ported from the **old Scala Play**-based original backend. 

Due the non-backwards compatibility that plagues the Scala programming language and related libraries, it is suggested to migrate the existent backend functionality to this Ruby on Rails web-based application.

Migrating from Scala to Ruby
-----------

The scala backend currently does two important task:

1. **Fetching task** : It mantains a listening process on the socket `6005` on UPD for new GPS updated locations for Pumabus buses, and registers each location as a new `Instant`.
2. **API task** : It routes requests that come from the two mobile frontends (iOS and Android) and from the web frontend and replies to them on a JSON format. Thus, the application work as an API service.

###Fetching task:
On the Scala Play application, this is implemented as an Akka actor that each second is listening to new packages being delivered through UPD on the mentioned port. The following Scala code does that:

    object Global extends GlobalSettings {
	
        override def onStart(app: Application) {
            Logger.info("Listening to vehicle reports")
            val vehicleListener = Akka.system.actorOf(Props[Listener], name = "vehicleListener")
    
	        Akka.system.scheduler.schedule(0 milliseconds, 1 second, vehicleListener, Listener.VehiclePositionChange);		  
        }
  
    }

The full code can be reviewed at the [Legacy Scala TUM] Github page. The class `Global.scala` is responsible for this behavior. The listener is defined under `app/actors` while the action the listener executes lives on `app/extractors`. A proper extractor **NEEDS** to be ported to ruby as well. 

Now, the best library available on ruby for having an background process running is to use [EventMachine]. In the following code fragment it is shown an example rake task which launches a job for performing a recurrent task listening on TCP.

    namespace :gps do
        desc "Starts a TCP server that fetches and integrates a GPS plot"
        task listener: :environment do
            require 'eventmachine'

            class EchoServer < EM::Connection
                def post_init
                    puts "-- someone connected to the echo server!"
                end

                def receive_data data
                    response_header = Instant.parse_plot(data)
        
                    p response_header
                    send_data(response_header)
                end
       
                def bind
                    p "Binded"
                end
       
                def unbind
                    puts "-- someone disconnected from the echo server!"
                end
            end

            # Launcher
            EventMachine.run {
                EventMachine.start_server "0.0.0.0", 3001, EchoServer
            }
        end

    end

###API task:
The API task is easier to implement, as it requires to migrate the routes definitions as defined on the [Legacy Scala TUM] routes file under `conf/routes` and implement the functionality that is implemented on their controllers on the new ruby-based application. 

**NOTE:** Pay attention on keeping the JSON payload unchanged so there are no missing objects on the mobile frontends after receiving and parsing the response from the server. If changes are required to the API routes or payload, the mobile frontends should be updated. 

Required static data
-----------

After deployment of this application, it is required to capture the GPS-Vehicle relation. This means it is required to register all the operating vehicles through the Management Interface on this application, together with it's IMEI and public number. This operation must be done at least once and whenever the relation changes.  

[Ruby on Rails]:http://rubyonrails.org/
[Postgis]:http://postgis.net/
[EventMachine]:https://github.com/eventmachine/eventmachine
[Legacy Scala TUM]:https://github.com/LaboratorioDisca/TUM
