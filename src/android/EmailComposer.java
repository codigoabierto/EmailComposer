package net.randymcmillan.emailcomposer;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
//import org.apache.cordova.CordovaInterface;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;

//import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.text.Html;
import android.util.Log;

public class EmailComposer extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals("showEmailComposer")) {
            final JSONObject parameters = args.getJSONObject(0);
            if(parameters != null){
            	cordova.getThreadPool().execute(new Runnable(){
            		public void run(){
		            	try{
		            		sendEmail(parameters);	
		            		//callbackContext.success("Sent email successfully");
		            	} catch(Exception e){
		            		callbackContext.error(e.toString());
		            	}
	            	}
            	});
            }
            return true;
        }
        return false;
    }

    private void sendEmail(JSONObject parameters) {

		final Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND_MULTIPLE);

		//String callback = parameters.getString("callback");

		boolean isHTML = false;
		try {
			isHTML = parameters.getBoolean("isHTML");
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling isHTML param: " + e.toString());
		}

		if (isHTML) {
			emailIntent.setType("text/html");
		} else {
			emailIntent.setType("text/plain");
		}

		// setting subject
		try {
			String subject = parameters.getString("subject");
			if (subject != null && subject.length() > 0) {
				emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling subject param: " + e.toString());
		}

		// setting body
		try {
			String body = parameters.getString("body");
			if (body != null && body.length() > 0) {
				if (isHTML) {
					emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, Html.fromHtml(body));
				} else {
					emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, body);
				}
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling body param: " + e.toString());
		}

		/*
		// setting TO recipients
		try {
			JSONArray toRecipients = parameters.getJSONArray("toRecipients");
			if (toRecipients != null && toRecipients.length() > 0) {
				String[] to = new String[toRecipients.length()];
				for (int i=0; i<toRecipients.length(); i++) {
					to[i] = toRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, to);
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling toRecipients param: " + e.toString());
		}

		// setting CC recipients
		try {
			JSONArray ccRecipients = parameters.getJSONArray("ccRecipients");
			if (ccRecipients != null && ccRecipients.length() > 0) {
				String[] cc = new String[ccRecipients.length()];
				for (int i=0; i<ccRecipients.length(); i++) {
					cc[i] = ccRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_CC, cc);
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling ccRecipients param: " + e.toString());
		}

		// setting BCC recipients
		try {
			JSONArray bccRecipients = parameters.getJSONArray("bccRecipients");
			if (bccRecipients != null && bccRecipients.length() > 0) {
				String[] bcc = new String[bccRecipients.length()];
				for (int i=0; i<bccRecipients.length(); i++) {
					bcc[i] = bccRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_BCC, bcc);
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling bccRecipients param: " + e.toString());
		}

		// setting attachments
		try {
			JSONArray attachments = parameters.getJSONArray("attachments");
			if (attachments != null && attachments.length() > 0) {
				ArrayList<Uri> uris = new ArrayList<Uri>();
				//convert from paths to Android friendly Parcelable Uri's
				for (int i=0; i<attachments.length(); i++) {
					try {
						File file = new File(attachments.getString(i));
						if (file.exists()) {
							Uri uri = Uri.fromFile(file);
							uris.add(uri);
						}
					} catch (Exception e) {
						Log.e("EmailComposer", "Error adding an attachment: " + e.toString());
					}
				}
				if (uris.size() > 0) {
					emailIntent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris);
				}
			}
		} catch (Exception e) {
			Log.e("EmailComposer", "Error handling attachments param: " + e.toString());
		}
		*/

		//this.cordova.startActivityForResult(this, emailIntent, 0);
		this.cordova.getActivity().startActivity(emailIntent);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		// TODO handle callback
		super.onActivityResult(requestCode, resultCode, intent);
		Log.e("EmailComposer", "ResultCode: " + resultCode);
		// IT DOESN'T SEEM TO HANDLE RESULT CODES
	}

}