using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http; 

namespace Funky.Learn.Bicep.Functions
{
    public class CreateCustomerFunction
    {
        [FunctionName(nameof(CreateCustomerFunction))]
        public async Task<IActionResult> CreateCustomerAsync([HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "customers")]
            HttpRequest request)
        {
            await Task.Delay(TimeSpan.FromSeconds(2));

            return new AcceptedResult();
        }
    }
}