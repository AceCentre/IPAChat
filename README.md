# IPAChat

what does this do?

We are wondering (Well with Andrea Lee) about the idea of using IPA (Phonemes) to construct messages in place of symbols for children. IPA is strange syntax but if you learn the sounds youc can babble and make any new words up and speak

In iOS there is a IPA notation API. We figured lets try hacking a quick app together to try it out. 

The search feature allows you to look up the IPA notation of a word. This is from: https://github.com/open-dict-data/ipa-dict. There are a lot of better tools in python (e.g. https://pypi.org/project/phonecodes/) but this is the best we can quickly hack up for iOS

We currently support french and English but ideally we should support as many languages as you can in iOS. Note the phonemes are different for different languages

We need to check all voices (or which voices) support this IPA Notation. 

Ideally we would like a way of putting your own images on phoneme buttons and moving them around. We have started the moving process in settings but it is ugly. This would be waaay better if someone from a mainstream AAC company just allowed IPA synthesis. 

## Demo

https://github.com/AceCentre/IPAChat/assets/229352/46b93d1d-ce01-4d6c-9f69-7cc409c3eccd


## How's it basically work?

SSML and using IPA. All the main libraries support this. See for example [Azure TTS](https://learn.microsoft.com/en-us/azure/ai-services/speech-service/speech-synthesis-markup-pronunciation#phoneme-element) [Google](https://cloud.google.com/text-to-speech/docs/ssml#phoneme) and others... 

We simply append a IPA character(s) to a string of IPA and push that through to the TTS engine wrapping it in the phoneme tag


e.g. 

```python

import requests

# Azure subscription key and service region
subscription_key = 'YourAzureSubscriptionKey'
service_region = 'YourServiceRegion'

# Set up the TTS endpoint
tts_endpoint = f'https://{service_region}.tts.speech.microsoft.com/cognitiveservices/v1'

# Set up the headers for the HTTP request
headers = {
    'Ocp-Apim-Subscription-Key': subscription_key,
    'Content-Type': 'application/ssml+xml',
    'X-Microsoft-OutputFormat': 'audio-16khz-32kbitrate-mono-mp3'
}

# The SSML document, including IPA notation for the word "dog"
ssml = """
<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>
    <voice name='en-US-AriaNeural'>
        <phoneme alphabet='ipa' ph='dɔg'>dog</phoneme>
    </voice>
</speak>
"""

# Make the HTTP request to the Azure TTS service
response = requests.post(tts_endpoint, headers=headers, data=ssml)

# Check if the request was successful
if response.status_code == 200:
    # Save the audio to a file
    with open('output.mp3', 'wb') as audio_file:
        audio_file.write(response.content)
    print("Audio saved to output.mp3")
else:
    print(f"Error: {response.status_code}")
    print(response.text)

```






