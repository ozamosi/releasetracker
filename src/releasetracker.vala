using GLib;
using Soup;
using Xml;

struct ReleaseInfo {
	public string name;
	public string category;
	public string link;
}

public class Main : GLib.Object {
	static int main (string[] args) {
		if (args.length != 2) {
			stdout.printf ("Usage: %s <filename>\n", args[0]);
			return 0;
		}

		var file = File.new_for_commandline_arg (args[1]);
		if (!file.query_exists (null)) {
			stderr.printf ("File '%s' doesn't exist.\n", file.get_path ());
			return 1;
		}

		try {
			var in_stream = new DataInputStream (file.read (null));
			string line;
			while ((line = in_stream.read_line (null, null)) != null) {
				stdout.printf ("%s:\n", line);
				do_request (line);
			}
		} catch (GLib.Error e) {
			error ("%s", e.message);
		}

		return 0;
	}

	private static void do_request (string movie_name)
		requires (movie_name != null && movie_name.length > 0)
	{
		var session = new Soup.SessionAsync ();
		var message = new Soup.Message ("GET", "http://scenereleases.info/category/movies?s=%s&feed=rss2".printf(Soup.URI.encode(movie_name, null)));

		session.send_message (message);
		Xml.Doc* xml_doc = Parser.parse_doc ((string) message.response_body.data);

		var ctxt = new Xml.XPath.Context (xml_doc);
		var objs = ctxt.eval_expression ("/rss/channel/item");
		for (var i = 0; i < objs->nodesetval->length (); i++) {
			var rinfo = ReleaseInfo ();
			var item = objs->nodesetval->item (i);
			for (var info = item->children; info != null; info = info->next) {
				if (info->type != Xml.ElementType.ELEMENT_NODE)
					continue;
				if (info->name == "title")
					rinfo.name = info->get_content ();
				else if (info->name == "category")
					rinfo.category = info->get_content ();
				else if (info->name == "link")
					rinfo.link = info->get_content ();
			}

			stdout.printf ("\t%s:\n", rinfo.name);
			stdout.printf ("\t\t%s\n", rinfo.category);
			stdout.printf ("\t\t%s\n", rinfo.link);
		}
	}
}
