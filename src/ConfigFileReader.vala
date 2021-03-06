using Granite.Widgets;

namespace RepositoriesManager {
public class ConfigFileReader : Gtk.ListBox{

   public string[] getRepositories (){
        string[] repositories = new string[0];

        File[] files = {};        
        try{
            var directory = Dir.open("/etc/apt/sources.list.d");

            files += getRepositoryFile("sources.list");

            while ((name = directory.read_name()) != null) {
                if("save" in name){
                    continue;
                }
                files += getRepositoryFile("sources.list.d/" + name);
            }

            foreach (File file in files) {
                try {
                    // Open file for reading and wrap returned FileInputStream into a
                    // DataInputStream, so we can read line by line
                    var lines = new DataInputStream (file.read ());
                    string line;

                    // Read lines until end of file (null) is reached
                    while ((line = lines.read_line (null)) != null) {
                        
                        if(line == ""){
                            continue;
                        }

                        if(!("deb" in line)){
                            continue;
                        }

                        repositories += line;
                    }
                } catch (Error e) {
                    error ("%s", e.message);
                }
            }
        } catch (Error e){
            new Alert("An error occured", e.message);
        }

        return repositories;
    }

    private File getRepositoryFile(string fileName){
        
        var sourcesFolder = File.new_for_path ("/etc/apt");
        if (!sourcesFolder.query_exists ()) {
            try {
                sourcesFolder.make_directory ();
            } catch (Error e) {
                error ("%s", e.message);
            }
        }

        var file = File.new_for_path ("/etc/apt/" + fileName);
        if (!file.query_exists ()) {
            try {
                file.create (FileCreateFlags.REPLACE_DESTINATION, null);
                getRepositoryFile(fileName);
            } catch (Error e) {
                error ("%s", e.message);
            }
        }
        return file;
    }

   
   
}
}
