import pandas as pd
import streamlit as st

from prometheus_client import REGISTRY, Counter, start_http_server


#@st.cache_resource # It is important to add a cache for streamlit to not load several time the metric server
def init_metrics():
	if not "counter_button_clicked" in st.session_state:
	    start_http_server(9000)
	    st.session_state.counter_button_clicked = Counter("button_clicked", "Number of times the button is clicked", registry=REGISTRY)

# Call init_metrics to initialize the counter
init_metrics()


text_nb_clicks = st.empty()
if st.button('Increment Counter'):
    st.session_state.counter_button_clicked.inc()
nb_clicks = int(st.session_state.counter_button_clicked._value.get())
text_nb_clicks.text(f"Button clicked {nb_clicks} {'time' if nb_clicks<2 else 'times'}")


st.title("Statistics and graphs based on the housing.csv file")

df = pd.read_csv("housing.csv")
st.dataframe(df.describe())

st.text("Population vs longitude")
st.scatter_chart(data=df, x="longitude", y="population")

st.text("Population vs latitude")
st.scatter_chart(data=df, x="latitude", y="population")
