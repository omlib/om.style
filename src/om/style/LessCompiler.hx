package om.style;

#if sys
import sys.io.Process;
#end

using om.ArrayTools;

typedef LessVar = {
	name : String,
	value : String
}

typedef Params = {
	?inlclude_paths : Array<String>,
	?depends  : Bool,
	?no_color : Bool,
	?no_ie_compat : Bool,
	?no_js : Bool,
	?lint : Bool,
	?silent : Bool,
	?strict_imports : Bool,
	?insecure : Bool,
	?compress : Bool,
	?clean : Bool,
	//?clean_options : Array<{}>,
	?source_map  : String,
	?source_map_rootpath  : String,
	?source_map_basepath  : String,
	?source_map_less_inline  : Bool,
	?source_map_map_inline  : Bool,
	?source_map_url  : String,
	?rootpath  : String,
	?relative_urls   : Bool,
	?strict_math   : Bool,
	?strict_unit   : Bool,
	?global_vars   : Array<LessVar>,
	?modify_vars   : Array<LessVar>
}

/**
	Less compiler wrapper.
*/
class LessCompiler {

	/**
	*/
	public static function getArgs( ?params : Params ) : Array<String> {
		var args = new Array<String>();
		if( params != null ) {
			if( params.inlclude_paths != null ) args.push( '--include-path='+params.inlclude_paths.join(':') );
			if( params.depends ) args.push( '--depends' );
			if( params.no_color ) args.push( '--no-color' );
			if( params.no_ie_compat ) args.push( '--no-ie-compat' );
			if( params.no_js ) args.push( '--no-js' );
			if( params.lint ) args.push( '--lint' );
			if( params.silent ) args.push( '--silent' );
			if( params.strict_imports ) args.push( '--strict_imports' );
			if( params.insecure ) args.push( '--insecure' );
			//if( params.compress ) args.push( '--compress' );
			//if( params.clean ) args.push( '--clean' );
			//if( params.clean_options )
			if( params.source_map != null ) args.push( '--source-map' );
			if( params.source_map_rootpath != null ) args.push( '--source-map-rootpath=' + params.source_map_rootpath );
			if( params.source_map_basepath != null ) args.push( '--source-map-basepath=' + params.source_map_basepath );
			if( params.source_map_less_inline != null ) args.push( '--source-map-less-inline=' + params.source_map_less_inline );
			if( params.source_map_map_inline != null ) args.push( '--source-map-map-inline=' + params.source_map_map_inline );
			if( params.source_map_url != null ) args.push( '--source-map-url=' + params.source_map_url );
			if( params.rootpath != null ) args.push( '--rootpath=' + params.rootpath );
			if( params.relative_urls != null ) args.push( '--relative_urls' );
			if( params.strict_math != null ) args.push( '--strict_math' );
			if( params.strict_math != null ) args.push( '--strict_math' );
			if( params.strict_unit != null ) args.push( '--strict_unit' );
			if( params.strict_unit != null ) args.push( '--strict_unit' );
			if( params.global_vars != null ) args.append( [for(v in params.global_vars)' --global-var=${v.name}=${v.value}'] );
			if( params.modify_vars != null ) args.append( [for(v in params.modify_vars)' --modify-var=${v.name}=${v.value}'] );
		}
		return args;
	}

	/*
	#if nodejs

	public static function compile( str : String, ?params : LesscParams, callback : String->Void ) {
		var args = getArgs( params ).add( '-' );
		trace(args);
		var lessc = js.node.ChildProcess.spawn( 'lessc', args );
		lessc.stdout.on( 'data', function(e) trace(e.toString()) );
		lessc.stderr.on( 'data', function(e) trace(e.toString()) );
		lessc.on( 'exit', function(code) trace(code) );
		trace(lessc.stdin.write(str));
	}

	#end
	*/

	#if sys

	public static function compile( str : String, ?params : Params, ?extraArgs : Array<String> ) : String {
		var args = getArgs( params ).add( '-' );
		if( extraArgs != null ) args = args.concat( extraArgs );
		var lessc = new Process( 'lessc', args );
		lessc.stdin.writeString( str );
        var e = lessc.stderr.readAll().toString();
        var r = lessc.stdout.readAll().toString();
        lessc.close();
        if( e.length > 0 )
            return e.toString();
        return null;
	}

	public static function compileFile( src : String, dst : String, ?params : Params, ?extraArgs : Array<String> ) : String {
		var args = getArgs( params ).append( [ src, dst ] );
		if( extraArgs != null ) args = args.concat( extraArgs );
		return execute( args );
		/*
		var lessc = new Process( 'lessc', args );
        var e = lessc.stderr.readAll().toString();
        var r = lessc.stdout.readAll().toString();
        lessc.close();
        if( e.length > 0 )
            return e.toString();
        return null;
		*/
	}

	public static function execute( args : Array<String> ) : String {
		var proc = new Process( 'lessc', args );
        var e = proc.stderr.readAll().toString();
        var r = proc.stdout.readAll().toString();
		proc.close();
        if( e.length > 0 )
            return throw e.toString();
		//return proc.exitCode();
        return null;
	}

	/*
    public static function build( src : String, dst : String, clean = false, compress = false ) : String{
        var args = [ src, dst, '--no-color' ];
        if( clean ) args.push( '--clean-css' );
        if( compress ) args.push( '-x' );
        var lessc = new Process( 'lessc', args );
        var e = lessc.stderr.readAll().toString();
        var r = lessc.stdout.readAll().toString();
        lessc.close();
        if( e.length > 0 )
            return e.toString();
        return null;
        /*
		if( srcName == null ) srcName = config.name;
		if( dstName == null ) dstName = srcName;
		var srcPath = 'res/style/$srcName.less';
		//var srcPath = 'res/style/$srcName-$platform.less';
		var dstPath = '$out/$dstName.css';

		var args = [ srcPath, dstPath, '--no-color' ];
		if( config.release ) {
			args.push( '-x' );
			args.push( '--clean-css' );
		}
		var lessc = new sys.io.Process( 'lessc', args );
		var e = lessc.stderr.readAll().toString();
		if( e.length > 0 )
			Context.error( e.toString(), Context.currentPos() );
		lessc.close();
        * /
	}
	*/

	#end

}
