using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;

namespace Web
{
    public class ChallengeResult : IHttpActionResult
    {
        public ChallengeResult(string loginProvider, ApiController controller)
        {
            LoginProvider = loginProvider;
            Request = controller.Request;
        }

        private string LoginProvider { get; set; }
        private HttpRequestMessage Request { get; set; }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken)
        {
            var response = new HttpResponseMessage(HttpStatusCode.Unauthorized) {RequestMessage = Request};
            return Task.FromResult(response);
        }
    }
}