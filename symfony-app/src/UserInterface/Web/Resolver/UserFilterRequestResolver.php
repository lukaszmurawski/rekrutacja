<?php

declare(strict_types=1);

namespace App\UserInterface\Web\Resolver;

use Symfony\Component\HttpFoundation\Request;
use App\UserInterface\Web\Request\UserFilterRequest;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\HttpKernel\Controller\ValueResolverInterface;
use Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadata;

class UserFilterRequestResolver implements ValueResolverInterface
{
    public function __construct(private ValidatorInterface $validator)
    {
    }

    public function supports(Request $request, ArgumentMetadata $argument): bool
    {
        return $argument->getType() === UserFilterRequest::class;
    }

    public function resolve(Request $request, ArgumentMetadata $argument): iterable
    {
        $query = $request->query->all();
        $filterRequest = new UserFilterRequest();

        foreach ($query as $key => $value) {
            if (property_exists($filterRequest, $key)) {
                $filterRequest->{$key} = $value;
            }
        }

        $errors = $this->validator->validate($filterRequest);

        if (count($errors) > 0) {
            $formatted = [];
            foreach ($errors as $error) {
                $formatted[$error->getPropertyPath()][] = $error->getMessage();
            }

            yield ['errors' => $formatted];
            return;
        }

        yield $filterRequest;
    }
}
